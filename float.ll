; ModuleID = 'GBL'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*, ...)

define i32 @main() {
entry:
  %a = alloca float
  store float 0x40450E1480000000, float* %a
  ret i32 0
}
