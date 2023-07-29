import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPF Validation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CpfPage(),
    );
  }
}

class CpfPage extends StatelessWidget {
  CpfPage({Key? key}) : super(key: key);

  final cpfController = TextEditingController();
  final cpfValidationNotifier = ValueNotifier<String>('');

  String formatCpf(String value) {
    value = value.replaceAll('.', '').replaceAll('-', '');
    if (value.length > 9) {
      value = value.replaceRange(9, value.length, '-${value.substring(9)}');
    }
    if (value.length > 6) {
      value = value.replaceRange(6, value.length, '.${value.substring(6)}');
    }
    if (value.length > 3) {
      value = value.replaceRange(3, value.length, '.${value.substring(3)}');
    }
    return value;
  }

  bool validateCpf(String value) {
    value = value.replaceAll('.', '').replaceAll('-', '');
    if (value.length != 11) return false;

    for (int i = 0; i < 10; i++) {
      if (value == "$i" * 11) return false;
    }

    List<int> cpf = value.split('').map((num) => int.parse(num)).toList();

    for (int i = 9; i < 11; i++) {
      int sum = 0;
      for (int j = 0; j < i; j++) {
        sum += cpf[j] * ((i + 1) - j);
      }
      int checkingDigit = sum % 11 < 2 ? 0 : 11 - sum % 11;
      if (checkingDigit != cpf[i]) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPF Validation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: cpfValidationNotifier,
                builder: (context, value, child) {
                  return Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  // cpfController.clear();
                  // cpfValidationNotifier.value = '';
                },
                controller: cpfController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Digite seu CPF',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    String value = cpfController.text;
                    value = formatCpf(value);
                    cpfController.text = value;
                    cpfController.selection =
                        TextSelection.fromPosition(TextPosition(
                      offset: value.length,
                    ));
                    if (validateCpf(value)) {
                      cpfValidationNotifier.value = 'CPF: $value - Válido';
                    } else {
                      cpfValidationNotifier.value = 'CPF: $value - Inválido';
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  label: const Text('validar'))
            ],
          ),
        ),
      ),
    );
  }
}
