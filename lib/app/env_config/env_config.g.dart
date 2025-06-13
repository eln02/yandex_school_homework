// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_config.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env
final class _EnvConfig {
  static const String useMocks = 'false';

  static const String baseUrl = 'https://shmr-finance.ru/api/v1/';

  static const List<int> _enviedkeytoken = <int>[
    3417258194,
    2017147858,
    2992631824,
    2885279177,
    1218315961,
    28817142,
    3611632696,
    2413013119,
    3001472071,
    96801715,
    3316422749,
    2953535702,
    3802008912,
    1523625539,
    3165146473,
    932131750,
    3824524441,
    3332244991,
    107569763,
    921111154,
    927551562,
    416413484,
    2739785741,
    1691451270,
  ];

  static const List<int> _envieddatatoken = <int>[
    3417258170,
    2017147818,
    2992631905,
    2885279225,
    1218316003,
    28817028,
    3611632652,
    2413013063,
    3001472016,
    96801759,
    3316422684,
    2953535668,
    3802008929,
    1523625474,
    3165146416,
    932131779,
    3824524522,
    3332244894,
    107569706,
    921111095,
    927551519,
    416413464,
    2739785855,
    1691451316,
  ];

  static final String token = String.fromCharCodes(
    List<int>.generate(
      _envieddatatoken.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddatatoken[i] ^ _enviedkeytoken[i]),
  );
}
