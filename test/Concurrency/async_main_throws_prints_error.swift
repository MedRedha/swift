// RUN: %empty-directory(%t)
// RUN: %target-build-swift  -Xfrontend -disable-availability-checking -Xfrontend -parse-as-library %s -o %t/main
// RUN: %target-codesign %t/main
// RUN: %target-run %t/main  > %t/log 2>&1 || true
// RUN: %FileCheck %s < %t/log

// REQUIRES: concurrency
// REQUIRES: executable_test
// REQUIRES: OS=macosx || OS=ios

// rdar://76038845
// UNSUPPORTED: use_os_stdlib
// UNSUPPORTED: back_deployment_runtime

enum Err : Error { case noGood }

func asyncFunc() async throws {
  throw Err.noGood
}

// CHECK: Fatal error: Error raised at top level: main.Err.noGood
@main struct MyProgram {
  static func main() async throws {
    try await asyncFunc()
  }
}
