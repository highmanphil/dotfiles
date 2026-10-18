import importlib.machinery
import importlib.util
from pathlib import Path
import unittest
from unittest.mock import patch

source = Path(__file__).resolve().parents[1] / 'cmux/.local/bin/cmux-remote-workspace-keeper'
loader = importlib.machinery.SourceFileLoader('keeper', str(source))
spec = importlib.util.spec_from_loader(loader.name, loader)
keeper = importlib.util.module_from_spec(spec)
loader.exec_module(keeper)


class KeeperTests(unittest.TestCase):
    def setUp(self):
        self.workspace = dict(id='workspace', pinned=True, selected=True, title='Home', remote=dict(
            enabled=True, backend='cmux-tui', connected=True, active_terminal_sessions=0,
            machine='ssh:home', destination='phil@100.104.47.26', remote_workspace_id='remote'))
        self.pane = dict(id='pane')
        self.old = dict(id='old', type='terminal', selected=True, tty=None)
        self.new = dict(id='new', type='terminal', tty=None)
        self.calls = []
        self.catalogs = [dict(resources=[]), dict(resources=[dict(kind='terminal', lifecycle='running',
                                                              open_surface_ids=['new'])])]

    def fake_cli(self, *args, **kwargs):
        self.calls.append(args)
        if args[:2] == ('surface', 'ls'):
            return self.catalogs.pop(0)
        if args[0] == 'rpc':
            return dict(surface_id='new')
        if args[0] == 'close-surface':
            return 'OK'
        self.fail(str(args))

    def exercise(self, after=None, before=None, expected_ids=None):
        before = before or [(self.pane, self.old)]
        after = after or [(self.pane, self.old), (self.pane, self.new)]
        with patch.object(keeper, 'cli', side_effect=self.fake_cli), \
             patch.object(keeper, 'surfaces', side_effect=[before, after]), \
             patch.object(keeper, 'idle_placeholder', return_value=True):
            keeper.repair(self.workspace, self.pane, self.old, expected_ids)

    def test_only_pinned_ready_allowed_empty_remote_is_candidate(self):
        self.assertTrue(keeper.candidate(self.workspace))
        for key, value in [('connected', False), ('active_terminal_sessions', 1),
                           ('backend', 'legacy'), ('destination', 'someone@else')]:
            changed = self.workspace | {'remote': self.workspace['remote'] | {key: value}}
            self.assertFalse(keeper.candidate(changed))
        self.assertFalse(keeper.candidate(self.workspace | {'pinned': False}))

    def test_restores_once_and_only_closes_exact_placeholder(self):
        self.exercise()
        self.assertEqual([c[1] for c in self.calls if c[0] == 'rpc'], ['surface.new_terminal'])
        self.assertIn(('close-surface', '--workspace', 'workspace', '--surface', 'old'), self.calls)

    def test_existing_live_projection_is_never_duplicated(self):
        self.catalogs = [dict(resources=[dict(kind='terminal', lifecycle='running',
                                             open_workspace_ids=['workspace'])])]
        self.exercise()
        self.assertFalse(any(c[0] == 'rpc' for c in self.calls))

    def test_existing_remote_view_is_reused(self):
        self.catalogs[0]['resources'] = [dict(id='resource', kind='terminal', lifecycle='running',
                                               remote_workspace=dict(id='remote'))]
        self.exercise()
        self.assertEqual([c[1] for c in self.calls if c[0] == 'rpc'], ['surface.project'])

    def test_user_opening_a_second_tab_cancels_repair(self):
        self.exercise(before=[(self.pane, self.old), (self.pane, dict(id='user'))])
        self.assertFalse(any(c[0] == 'rpc' for c in self.calls))

    def test_failed_new_projection_preserves_placeholder(self):
        self.catalogs[1] = dict(resources=[])
        self.exercise()
        self.assertFalse(any(c[0] == 'close-surface' for c in self.calls))

    def test_user_tab_created_during_repair_is_preserved(self):
        self.exercise(after=[(self.pane, self.old), (self.pane, self.new), (self.pane, dict(id='user'))])
        self.assertIn(('close-surface', '--workspace', 'workspace', '--surface', 'old'), self.calls)
        self.assertFalse(any(c[0] == 'close-surface' and c[-1] == 'user' for c in self.calls))

    def test_existing_other_tabs_are_preserved(self):
        other = (self.pane, dict(id='other'))
        self.exercise(before=[(self.pane, self.old), other],
                      after=[(self.pane, self.old), other, (self.pane, self.new)],
                      expected_ids={'old', 'other'})
        self.assertIn(('close-surface', '--workspace', 'workspace', '--surface', 'old'), self.calls)
        self.assertFalse(any(c[0] == 'close-surface' and c[-1] == 'other' for c in self.calls))

    def test_busy_local_shell_is_not_a_placeholder(self):
        with patch.object(keeper.os.path, 'exists', return_value=True), \
             patch.object(keeper.subprocess, 'run') as run:
            run.return_value.stdout = '-zsh\n/usr/bin/vim\n'
            self.assertFalse(keeper.idle_placeholder(dict(type='terminal', tty='ttys001')))
            run.return_value.stdout = '/usr/bin/login\n-zsh\n/gitstatusd-darwin-arm64\n'
            self.assertTrue(keeper.idle_placeholder(dict(type='terminal', tty='ttys001')))


if __name__ == '__main__':
    unittest.main()
