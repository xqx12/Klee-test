; ModuleID = 'bench_test.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [6 x i8] c"argv2\00", align 1

define i32 @int_overflow(i32 %size) nounwind {
entry:
  %size_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %size, i32* %size_addr
  %1 = load i32* %size_addr, align 4
  %2 = mul nsw i32 %1, 100
  store i32 %2, i32* %0, align 4
  %3 = load i32* %0, align 4
  store i32 %3, i32* %retval, align 4
  br label %return

return:                                           ; preds = %entry
  %retval1 = load i32* %retval
  ret i32 %retval1
}

define i32 @div_zero(i32 %divisor) nounwind {
entry:
  %divisor_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %divisor, i32* %divisor_addr
  %1 = load i32* %divisor_addr, align 4
  %2 = sdiv i32 %1, 0
  store i32 %2, i32* %0, align 4
  %3 = load i32* %0, align 4
  store i32 %3, i32* %retval, align 4
  br label %return

return:                                           ; preds = %entry
  %retval1 = load i32* %retval
  ret i32 %retval1
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %argc_addr = alloca i32, align 4
  %argv_addr = alloca i8**, align 8
  %retval = alloca i32
  %0 = alloca i32
  %str = alloca [3 x i8]
  %argv1 = alloca i32
  %argv2 = alloca [16 x i8]
  %i = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %argc, i32* %argc_addr
  store i8** %argv, i8*** %argv_addr
  %1 = getelementptr inbounds [3 x i8]* %str, i64 0, i64 0
  store i8 97, i8* %1, align 1
  %2 = getelementptr inbounds [3 x i8]* %str, i64 0, i64 1
  store i8 97, i8* %2, align 1
  %3 = load i8*** %argv_addr, align 8
  %4 = getelementptr inbounds i8** %3, i64 1
  %5 = load i8** %4, align 1
  %6 = call i32 (...)* @atoi(i8* %5) nounwind
  store i32 %6, i32* %argv1, align 4
  %7 = load i8*** %argv_addr, align 8
  %8 = getelementptr inbounds i8** %7, i64 2
  %9 = load i8** %8, align 1
  %argv21 = bitcast [16 x i8]* %argv2 to i8*
  %10 = call i8* @strcpy(i8* noalias %argv21, i8* noalias %9) nounwind
  %argv22 = bitcast [16 x i8]* %argv2 to i8*
  %11 = call i32 (...)* @klee_make_symbolic(i8* %argv22, i32 16, i8* getelementptr inbounds ([6 x i8]* @.str, i64 0, i64 0)) nounwind
  %12 = load i32* %argv1, align 4
  %13 = icmp sle i32 %12, 2
  br i1 %13, label %bb, label %bb3

bb:                                               ; preds = %entry
  store i32 -1, i32* %0, align 4
  br label %bb11

bb3:                                              ; preds = %entry
  store i32 0, i32* %i, align 4
  br label %bb9

bb4:                                              ; preds = %bb9
  %14 = load i32* %i, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [16 x i8]* %argv2, i64 0, i64 %15
  %17 = load i8* %16, align 1
  %18 = icmp eq i8 %17, 42
  br i1 %18, label %bb5, label %bb6

bb5:                                              ; preds = %bb4
  %19 = load i32* %i, align 4
  %20 = call i32 @int_overflow(i32 %19) nounwind
  br label %bb6

bb6:                                              ; preds = %bb5, %bb4
  %21 = load i32* %i, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [16 x i8]* %argv2, i64 0, i64 %22
  %24 = load i8* %23, align 1
  %25 = icmp eq i8 %24, 48
  br i1 %25, label %bb7, label %bb8

bb7:                                              ; preds = %bb6
  %26 = load i32* %i, align 4
  %27 = call i32 @div_zero(i32 %26) nounwind
  br label %bb8

bb8:                                              ; preds = %bb7, %bb6
  %28 = load i32* %i, align 4
  %29 = add nsw i32 %28, 1
  store i32 %29, i32* %i, align 4
  br label %bb9

bb9:                                              ; preds = %bb8, %bb3
  %30 = load i32* %i, align 4
  %31 = load i32* %argv1, align 4
  %32 = icmp slt i32 %30, %31
  br i1 %32, label %bb4, label %bb10

bb10:                                             ; preds = %bb9
  store i32 0, i32* %0, align 4
  br label %bb11

bb11:                                             ; preds = %bb10, %bb
  %33 = load i32* %0, align 4
  store i32 %33, i32* %retval, align 4
  br label %return

return:                                           ; preds = %bb11
  %retval12 = load i32* %retval
  ret i32 %retval12
}

declare i32 @atoi(...)

declare i8* @strcpy(i8* noalias, i8* noalias) nounwind

declare i32 @klee_make_symbolic(...)
