abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class SwipeLimitFailure extends Failure {
  const SwipeLimitFailure() : super("Daily swipe limit reached! Upgrade to Pro.");
}
