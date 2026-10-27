import 'dart:async';

abstract class Maintainable {
  Future<void> serviceEngine();
}

mixin GPSNavigable {
  Future<String> fetchRoute(String destination) async {
    await Future.delayed(Duration(seconds: 2));
    return 'Optimal route to $destination calculated successfully.';
  }
}

abstract class Tricycle implements Maintainable {
  String _color;
  bool isEngineRunning = false;

  Tricycle(this._color);

  String get color => _color;
  set color(String newColor) {
    if (newColor == 'silver' || newColor == 'black' || newColor == 'white') {
      _color = newColor;
    } else {
      print('Invalid color choice! Choose silver, black, or white.');
    }
  }

  Future<void> kickstartEngine() async {
    await Future.delayed(Duration(seconds: 1));
    isEngineRunning = true;
    print('The $_color tricycle engine is running: Vroom vroom!');
  }

  Future<void> honk() async {
    await Future.delayed(Duration(seconds: 1));
    print('The $_color tricycle honks: Beep beep!');
  }

  Future<String> saveTripLog(String tripDetails) async {
    await Future.delayed(Duration(seconds: 2));
    return 'SUCCESS: Trip log saved ($tripDetails)';
  }
}

class PassengerTricycle extends Tricycle {
  int passengerCapacity;

  PassengerTricycle(String color, this.passengerCapacity) : super(color);

  @override
  Future<void> honk() async {
    await Future.delayed(Duration(seconds: 1));
    print('Passenger Tricycle ($_color): "BEEP BEEP! Commuters board now!"');
  }

  @override
  Future<void> serviceEngine() async {
    await Future.delayed(Duration(seconds: 1));
    print('Service Complete: Checked passenger safety & brakes.');
  }

  Future<void> loadPassengers(int count) async {
    await Future.delayed(Duration(seconds: 1));
    if (count <= passengerCapacity) {
      print('Loaded $count passenger(s) into the sidecar.');
    } else {
      print('Overload! Capacity limit is $passengerCapacity passengers.');
    }
  }
}

class CargoTricycle extends Tricycle with GPSNavigable {
  double maxCargoKg;

  CargoTricycle(String color, this.maxCargoKg) : super(color);

  @override
  Future<void> kickstartEngine() async {
    await Future.delayed(Duration(seconds: 1));
    isEngineRunning = true;
    print('Cargo Tricycle ($_color): Engine roaring! Ready for heavy load.');
  }

  @override
  Future<void> serviceEngine() async {
    await Future.delayed(Duration(seconds: 1));
    print('Service Complete: Inspected heavy-duty suspension & tires.');
  }

  Future<void> loadCargo(double weight) async {
    await Future.delayed(Duration(seconds: 1));
    print('Loaded ${weight}kg of cargo (Max capacity: ${maxCargoKg}kg).');
  }

  Future<String> fetchDispatchStatus() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Dispatch Status: Cargo verified and cleared for delivery.';
  }
}

Future<void> main() async {
  

  PassengerTricycle passengerTrike = PassengerTricycle('silver', 4);
  CargoTricycle cargoTrike = CargoTricycle('black', 250.0);

  print(' Initiating trip logging...');
  Future<String> saveOperation = passengerTrike.saveTripLog('Route 4 - City Center');
  print('System continues running while data saves in background...\n');

  print('Fetching cargo dispatch status...');
  Future<String> dispatchOperation = cargoTrike.fetchDispatchStatus();
  print('UI remains responsive while fetching dispatch info...\n');

  await passengerTrike.kickstartEngine();
  await passengerTrike.honk();
  await passengerTrike.loadPassengers(3);
  await passengerTrike.serviceEngine();

  print('');

  await cargoTrike.kickstartEngine();
  await cargoTrike.loadCargo(150.0);

  print('Requesting route...');
  String routeResult = await cargoTrike.fetchRoute('Central Market');
  print(routeResult);

  print('\n=== AWAITING BACKGROUND OPERATIONS ===');
  String saveResult = await saveOperation;
  print(saveResult);

  String dispatchResult = await dispatchOperation;
  print(dispatchResult);

  print('\n=== DEMO COMPLETED ===');
}
