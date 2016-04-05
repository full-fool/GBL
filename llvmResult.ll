; ModuleID = 'GBL'

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@str = private unnamed_addr constant [12 x i8] c"hello world\00"

declare i32 @printf(i8*, ...)

declare i32 @puts(i8*, ...)

define i32 @main() {
entry:
  %0 = call i32 (i8*, ...)* @puts(i8* getelementptr inbounds ([12 x i8]* @str, i32 0, i32 0))
  ret i32 0
}
