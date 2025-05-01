import 'package:project/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AppState.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: AmbulanceApp(),
    ),
  );
}

class AmbulanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ambulance Management System',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          displayMedium: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: const WidgetTree(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardPage(),
    TrackingPage(),
    EquipmentPage(),
    AboutPage(),
    ContactPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance Management System'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Login',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Tracking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: 'Equipment'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: _onItemTapped,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Sign Up', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Already have an account? Login',
                  style: TextStyle(color: Colors.redAccent)),
            )
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardCard(
                        context,
                        icon: Icons.directions_car,
                        title: 'Active Ambulances',
                        subtitle: '5 available',
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.local_hospital,
                        title: 'Missions in Progress',
                        subtitle:
                            '${appState.missionsInProgress} active missions',
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.check_circle,
                        title: 'Total Missions Completed',
                        subtitle:
                            '${appState.totalMissionsCompleted} missions completed',
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        context,
                        icon: Icons.report,
                        title: 'Reports',
                        subtitle: 'View detailed reports',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MissionHistoryPage()),
                      );
                    },
                    child: Text('View Mission History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewMissionPage(
                            equipmentStock: {
                              'Defibrillator': 10,
                              'Oxygen Tank': 5,
                              'First Aid Kit': 8,
                            },
                            onMissionStarted: () {
                              final appState =
                                  Provider.of<AppState>(context, listen: false);
                              appState.incrementMissionsInProgress();
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                    ),
                    child: Text('Start New Mission',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildDashboardCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Card(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.redAccent),
            SizedBox(height: 12),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black87)),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    ),
  );
}

class NewMissionPage extends StatefulWidget {
  final Map<String, int> equipmentStock;
  final VoidCallback onMissionStarted;
// Inside your NewMissionPage or wherever you complete the mission
  void completeMission(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    // Call completeMission to update the state
    appState.completeMission();

    // Navigate back or show a success message
    Navigator.pop(context);
  }

  NewMissionPage({
    required this.equipmentStock,
    required this.onMissionStarted,
  });

  @override
  _NewMissionPageState createState() => _NewMissionPageState();
}

class _NewMissionPageState extends State<NewMissionPage> {
  Map<String, int> equipmentUsage = {
    'Defibrillator': 0,
    'Oxygen Tank': 0,
    'First Aid Kit': 0,
  };

  String? selectedDriver;
  final List<String> availableDrivers = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson'
  ];

  void _assignDriver(String? driver) {
    setState(() {
      selectedDriver = driver;
    });
  }

  void _startMission(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    equipmentUsage.forEach((item, quantityUsed) {
      if (quantityUsed > 0) {
        appState.updateEquipment(item, -quantityUsed);
      }
    });

    appState.incrementMissions();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start New Mission')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Equipment for the Mission',
                style: Theme.of(context).textTheme.titleLarge),
            for (var entry in equipmentUsage.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key,
                        style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (equipmentUsage[entry.key]! > 0) {
                              setState(() {
                                equipmentUsage[entry.key] =
                                    equipmentUsage[entry.key]! - 1;
                              });
                            }
                          },
                        ),
                        Text(entry.value.toString(),
                            style: Theme.of(context).textTheme.bodyMedium),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (Provider.of<AppState>(context, listen: false)
                                    .getEquipmentStock(entry.key) >
                                equipmentUsage[entry.key]!) {
                              setState(() {
                                equipmentUsage[entry.key] =
                                    equipmentUsage[entry.key]! + 1;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Not enough stock for ${entry.key}')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text(' Assign Driver',
                style: Theme.of(context).textTheme.titleLarge),
            DropdownButton<String>(
              value: selectedDriver,
              hint: Text('Select Driver'),
              items: availableDrivers.map((driver) {
                return DropdownMenuItem<String>(
                  value: driver,
                  child: Text(driver),
                );
              }).toList(),
              onChanged: _assignDriver,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startMission(context),
              child: Text('Start Mission'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About Us',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(
                'The Ambulance Management System provides an intuitive platform for tracking ambulances, managing missions, and organizing equipment.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87, height: 1.6),
              ),
              SizedBox(height: 20),
              Text('Key Features:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              BulletPointText('Efficient Ambulance Tracking'),
              BulletPointText('Real-Time Data Monitoring'),
              BulletPointText('Driver Availability Tracking'),
              BulletPointText('Equipment Management'),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent, width: 1),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Our mission is to ensure that every ambulance is equipped and ready to respond to emergencies promptly.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        height: 1.6,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'We believe in leveraging technology to enhance emergency response systems and save lives.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPointText extends StatelessWidget {
  final String text;

  BulletPointText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: Colors.redAccent),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get in Touch',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                'We value your feedback and inquiries. Reach out to us via phone, email, or send us a message directly.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87, height: 1.6),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.redAccent),
                title: Text('Phone:',
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text('+1 (800) 123-4567',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.redAccent),
                title: Text('Email:',
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text('support@ambulancemgmt.com',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              SizedBox(height: 20),
              Text('Send Us a Message',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your Message',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Message Sent Successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  ),
                  child: Text('Send Message', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final Set<Marker> _markers = {};
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12);

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.addAll([
      Marker(
        markerId: MarkerId('ambulance1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(title: 'Ambulance 1', snippet: 'Available'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: MarkerId('ambulance2'),
        position: LatLng(37.7849, -122.4294),
        infoWindow: InfoWindow(title: 'Ambulance 2', snippet: 'On Mission'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
      Marker(
        markerId: MarkerId('ambulance3'),
        position: LatLng(37.7949, -122.4394),
        infoWindow: InfoWindow(title: 'Ambulance 3', snippet: 'Off Duty'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDriverInfo(
                  name: 'John Doe',
                  status: 'Available',
                  statusColor: Colors.green,
                ),
                _buildDriverInfo(
                  name: 'Jane Smith',
                  status: 'On Mission',
                  statusColor: Colors.orange,
                ),
                _buildDriverInfo(
                  name: 'Mark Taylor',
                  status: 'Available',
                  statusColor: Colors.green,
                ),
                _buildDriverInfo(
                  name: 'Sarah Johnson',
                  status: 'Off Duty',
                  statusColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo({
    required String name,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.directions_car, color: Colors.redAccent),
        title: Text(name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(status, style: TextStyle(color: statusColor)),
        trailing: Icon(
          status == 'Off Duty' ? Icons.location_off : Icons.location_on,
          color: statusColor,
        ),
      ),
    );
  }
}

class MissionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Mission History')),
      body: ListView.builder(
        itemCount: appState.completedMissions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(appState.completedMissions[index]),
          );
        },
      ),
    );
  }
}

class EquipmentPage extends StatefulWidget {
  @override
  _EquipmentPageState createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Equipment Stock',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              SizedBox(height: 10),
              Text(
                'Adjust stock levels to ensure ambulance readiness for any mission.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.6,
                    ),
              ),
              SizedBox(height: 20),
              for (var entry in appState.equipmentStock.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key,
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text(
                            entry.value.toString(),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Note: Ensure accurate stock updates for optimal mission readiness.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
