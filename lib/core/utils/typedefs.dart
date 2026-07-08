import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
