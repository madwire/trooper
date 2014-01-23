# Changelog

## 0.7.0
- You can now import other troopfiles
- Update Dependency - net-ssh ~> 2.7.0

## 0.6.3
- configuration is now not responsible for executing a strategy
- fixed cli options typo
- ignore HostKeyMismatch
- Update Dependency - net-ssh ~> 2.6.8

## 0.6.2
- Update Dependency - net-ssh ~> 2.5.2
- Actions now validate before adding to store
- New Default Pre-compile Assets action added
- Local execute didn't handle exceptions correctly

## 0.6.1
- Actions can expect an on option to limit when it runs
- Strategies should not be able to add a prerequisite that has a local action

## 0.6.0
- Init Public Release