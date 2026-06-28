import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress.dart';

final progressProvider = Provider<ProgressModel>((ref) => ProgressModel.seed);
