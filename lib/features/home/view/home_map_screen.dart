import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:task/core/theme/app_text_styles.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_constants.dart';
import 'package:task/features/home/viewmodel/home_map_viewmodel.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});
  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<HomeMapViewModel>();
      viewModel.loadCurrentUser();
      viewModel.generateInterpolatedRoute();
    });
  }

  void _startMovement() {
    final viewModel = context.read<HomeMapViewModel>();
    viewModel.startCarMovement((position, bearing) {
      _mapController.move(position, 15.5);
    });
  }

  void _handleLogout() async {
    final viewModel = context.read<HomeMapViewModel>();
    await viewModel.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeMapViewModel>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: viewModel.routePoints.isNotEmpty
                  ? viewModel.routePoints.first
                  : const LatLng(28.5355, 77.3910),
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.task.app',
              ),
              PolylineLayer(
                polylines: [
                  if (viewModel.routePoints.isNotEmpty)
                    Polyline(
                      points: viewModel.routePoints,
                      color: Theme.of(context).colorScheme.secondary,
                      strokeWidth: 5.0,
                      strokeJoin: StrokeJoin.round,
                      strokeCap: StrokeCap.round,
                    ),
                ],
              ),
              Consumer<HomeMapViewModel>(
                builder: (context, vm, child) {
                  return MarkerLayer(
                    markers: [
                      if (vm.routePoints.isNotEmpty) ...[
                        Marker(
                          point: vm.routePoints.first,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 40,
                          ),
                        ),
                        Marker(
                          point: vm.routePoints.last,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                      if (vm.routePoints.isNotEmpty)
                        Marker(
                          point: vm.currentCarPosition,
                          width: 60,
                          height: 60,
                          child: Transform.rotate(
                            angle: vm.carBearing * (math.pi / 180),
                            child: Image.asset('assets/images/car.png'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Consumer<HomeMapViewModel>(
              builder: (context, vm, child) {
                final user = vm.currentUser;
                return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    backgroundImage: user?.imagePath != null
                        ? FileImage(File(user!.imagePath!))
                        : null,
                    child: user?.imagePath == null
                        ? Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.name ?? 'Guest User',
                          style: AppTextStyles.headline(
                            context,
                          ).copyWith(fontSize: 16),
                        ),
                        Text(
                          user?.email ?? 'guest@example.com',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: _handleLogout,
                  ),
                ],
              ),
            );
          },
        ),
      ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Consumer<HomeMapViewModel>(
              builder: (context, vm, child) {
                return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route Simulation',
                            style: AppTextStyles.headline(
                              context,
                            ).copyWith(fontSize: 16),
                          ),
                          Text(
                            'Sector 62 to India Gate',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: viewModel.isMoving
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          viewModel.isMoving ? 'RUNNING' : 'IDLE',
                          style: TextStyle(
                            color: viewModel.isMoving
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: viewModel.isMoving ? null : _startMovement,
                          icon: const Icon(Icons.play_arrow),
                          label: Text(
                            'Start Ride',
                            style: AppTextStyles.buttonText(
                              context,
                            ).copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(16),
                          icon: Icon(
                            Icons.stop,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: viewModel.isMoving
                              ? viewModel.stopCarMovement
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
        ],
      ),
    );
  }
}
