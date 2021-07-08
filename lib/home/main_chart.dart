import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartExpenses extends StatelessWidget {
  final List<ChartData> chartData;
  const PieChartExpenses({Key key, this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SfCircularChart(
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          //title: LegendTitle(text: 'hola')),
          series: <CircularSeries>[
            // Render pie chart
            PieSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    // Positioning the data label
                    labelPosition: ChartDataLabelPosition.outside))
          ]),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}
