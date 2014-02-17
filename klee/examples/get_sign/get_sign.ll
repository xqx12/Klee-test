; ModuleID = 'get_sign.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@buf = common unnamed_addr global i8* null

define i32 @get_sign(i32 %x) nounwind {
entry:
  %x_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  call void @llvm.dbg.declare(metadata !{i32* %x_addr}, metadata !13), !dbg !14
  store i32 %x, i32* %x_addr
  %1 = load i32* %x_addr, align 4, !dbg !15
  %2 = icmp eq i32 %1, 0, !dbg !15
  br i1 %2, label %exit, label %bb, !dbg !15

bb:                                               ; preds = %entry
  %3 = load i32* %x_addr, align 4, !dbg !17
  %4 = icmp slt i32 %3, 0, !dbg !17
  br i1 %4, label %bb1, label %bb2, !dbg !17

bb1:                                              ; preds = %bb
  store i32 -1, i32* %0, align 4, !dbg !18
  br label %bb3, !dbg !18

bb2:                                              ; preds = %bb
  %5 = load i32* %x_addr, align 4, !dbg !19
  %6 = sext i32 %5 to i64, !dbg !19
  %7 = call noalias i8* @malloc(i64 %6) nounwind, !dbg !19
  store i8* %7, i8** @buf, align 8, !dbg !19
  br label %exit, !dbg !20

exit:                                             ; preds = %bb2, %entry
  %8 = load i8** @buf, align 8, !dbg !21
  call void @free(i8* %8) nounwind, !dbg !21
  store i32 0, i32* %0, align 4, !dbg !22
  br label %bb3, !dbg !22

bb3:                                              ; preds = %exit, %bb1
  %9 = load i32* %0, align 4, !dbg !18
  store i32 %9, i32* %retval, align 4, !dbg !18
  br label %return, !dbg !18

return:                                           ; preds = %bb3
  %retval4 = load i32* %retval, !dbg !18
  ret i32 %retval4, !dbg !18
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare noalias i8* @malloc(i64) nounwind

declare void @free(i8*) nounwind

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %argc_addr = alloca i32, align 4
  %argv_addr = alloca i8**, align 8
  %retval = alloca i32
  %0 = alloca i32
  %a = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  call void @llvm.dbg.declare(metadata !{i32* %argc_addr}, metadata !23), !dbg !24
  store i32 %argc, i32* %argc_addr
  call void @llvm.dbg.declare(metadata !{i8*** %argv_addr}, metadata !25), !dbg !24
  store i8** %argv, i8*** %argv_addr
  call void @llvm.dbg.declare(metadata !{i32* %a}, metadata !26), !dbg !28
  %1 = load i32* %argc_addr, align 4, !dbg !29
  %2 = icmp sle i32 %1, 1, !dbg !29
  br i1 %2, label %bb, label %bb1, !dbg !29

bb:                                               ; preds = %entry
  store i32 0, i32* %0, align 4, !dbg !29
  br label %bb2, !dbg !29

bb1:                                              ; preds = %entry
  %3 = load i8*** %argv_addr, align 8, !dbg !30
  %4 = getelementptr inbounds i8** %3, i64 1, !dbg !30
  %5 = load i8** %4, align 1, !dbg !30
  %6 = call i32 @atoi(i8* %5) nounwind readonly, !dbg !30
  store i32 %6, i32* %a, align 4, !dbg !30
  %7 = load i32* %a, align 4, !dbg !31
  %8 = call i32 @get_sign(i32 %7) nounwind, !dbg !31
  store i32 %8, i32* %0, align 4, !dbg !31
  br label %bb2, !dbg !31

bb2:                                              ; preds = %bb1, %bb
  %9 = load i32* %0, align 4, !dbg !29
  store i32 %9, i32* %retval, align 4, !dbg !29
  br label %return, !dbg !29

return:                                           ; preds = %bb2
  %retval3 = load i32* %retval, !dbg !29
  ret i32 %retval3, !dbg !29
}

declare i32 @atoi(i8*) nounwind readonly

!llvm.dbg.sp = !{!0, !6}
!llvm.dbg.gv = !{!12}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"get_sign", metadata !"get_sign", metadata !"get_sign", metadata !1, i32 11, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @get_sign} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"get_sign.c", metadata !"/home/xqx/projects/klee-test/klee/examples/get_sign/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"get_sign.c", metadata !"/home/xqx/projects/klee-test/klee/examples/get_sign/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"main", metadata !1, i32 27, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, null} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !5, metadata !5, metadata !9}
!9 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!11 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 589876, i32 0, metadata !1, metadata !"buf", metadata !"buf", metadata !"", metadata !1, i32 9, metadata !10, i1 false, i1 true, i8** @buf} ; [ DW_TAG_variable ]
!13 = metadata !{i32 590081, metadata !0, metadata !"x", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!14 = metadata !{i32 11, i32 0, metadata !0, null}
!15 = metadata !{i32 12, i32 0, metadata !16, null}
!16 = metadata !{i32 589835, metadata !0, i32 11, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!17 = metadata !{i32 15, i32 0, metadata !16, null}
!18 = metadata !{i32 16, i32 0, metadata !16, null}
!19 = metadata !{i32 19, i32 0, metadata !16, null}
!20 = metadata !{i32 22, i32 0, metadata !16, null}
!21 = metadata !{i32 23, i32 0, metadata !16, null}
!22 = metadata !{i32 24, i32 0, metadata !16, null}
!23 = metadata !{i32 590081, metadata !6, metadata !"argc", metadata !1, i32 27, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 27, i32 0, metadata !6, null}
!25 = metadata !{i32 590081, metadata !6, metadata !"argv", metadata !1, i32 27, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!26 = metadata !{i32 590080, metadata !27, metadata !"a", metadata !1, i32 28, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!27 = metadata !{i32 589835, metadata !6, i32 27, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!28 = metadata !{i32 28, i32 0, metadata !27, null}
!29 = metadata !{i32 29, i32 0, metadata !27, null}
!30 = metadata !{i32 30, i32 0, metadata !27, null}
!31 = metadata !{i32 32, i32 0, metadata !27, null}
