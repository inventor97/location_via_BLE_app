package com.example.location_via_ble_app

import androidx.annotation.NonNull
import com.lemmingapex.trilateration.NonLinearLeastSquaresSolver
import com.lemmingapex.trilateration.TrilaterationFunction
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.apache.commons.math3.fitting.leastsquares.LevenbergMarquardtOptimizer


class MainActivity : FlutterActivity() {
    private val CHANNEL = "BEACONS"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.hasArgument("coordinates")) {
                val  cells = call.argument<List<List<Double>>>("coordinates")

                val beaconData: Array<DoubleArray> = Array(cells!!.size) { i -> cells[i].toDoubleArray() }

                var beaconCoordinates: Array<DoubleArray> = arrayOf<DoubleArray>()
                var beaconDistances: DoubleArray = doubleArrayOf()

                for (coordinates in beaconData) {
                    beaconCoordinates += (doubleArrayOf(coordinates[0], coordinates[1]))
                    beaconDistances += coordinates[2]
                }

                val solver = NonLinearLeastSquaresSolver(TrilaterationFunction(beaconCoordinates, beaconDistances), LevenbergMarquardtOptimizer())
                val optimum = solver.solve(true)
                val centroid = optimum.point.toArray()
                result.success(centroid)
            }
        }
    }
}
