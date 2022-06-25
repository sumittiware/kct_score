import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kct_score/model/department_model.dart';

List<Color> colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.blueGrey,
  Colors.teal,
  Colors.deepPurple
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KCT Scores'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection('KCT').doc('d').snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = ((snapshot.data as DocumentSnapshot).data()
                as Map<String, dynamic>)['department'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    KCTChart(
                      data: fromJSON(
                        data,
                      ),
                    ),
                    const Text("Scores of Departments",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    _buildScoreList(
                      fromJSON(
                        data,
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget _buildScoreList(List<Department> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
          data.length,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${data[index].name} : ${data[index].score}",
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              )),
    );
  }
}

class KCTChart extends StatelessWidget {
  final List<Department> data;

  const KCTChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Department, String>> series = [
      charts.Series(
          id: "departments",
          data: data,
          domainFn: (Department series, _) => series.name,
          measureFn: (Department series, _) => series.score,
          colorFn: (Department series, _) =>
              charts.ColorUtil.fromDartColor(colors[series.id])),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(12),
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}
