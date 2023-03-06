@echo off
setlocal EnableDelayedExpansion

rem 因为bat中百分号%%中变量是从左到右依次替换得，不增加上条命令会导致如%IPADDR[%i%]%，变成变量%IPADDR[%，字符i，变量%]%

rem 服务器ip地址的输入，通过set /p获得，/p参数可以让bat在用户赋值前显示提示内容。通过IPADDR_NUM来对数组索引计数。

set /a IPADDR_NUM=0
:INPUT
set /P IPADDR[%IPADDR_NUM%]="Enter your server IP address:"

rem 确认用户是否要继续输入,没有找到:ModelName作用域的文档，所以不太清楚一个模块在什么情况下会继续执行相关后续命令，所以使用了goto直接执行后续命令。

:CONFIRM
set /P CONFIRM_ADD="Are you want to continue add?(y/n)"
 if %CONFIRM_ADD%==y (
  set /a IPADDR_NUM+=1
  goto INPUT
)
 if %CONFIRM_ADD%==n (
  goto OUTPUT
 )
 if not %CONFIRM_ADD%==y if not %CONFIRM_ADD%==n (
  echo ERROR,please reconfirm:
  goto CONFIRM
 )

rem 确认和执行环节，需要注意数组索引也使用变量的写法，数组在echo中的输出，只能使用!ARR[%%i]!，如果使用%ARR[!i!]%，则会输出错误结果

:OUTPUT
for /l %%i in (0 1 %IPADDR_NUM%) do (
    echo !IPADDR[%%i]!
)
echo Your server ip address list,please check,if incorrect,Enter Ctrl + C close CMD,and rerun.
pause
for /l %%i in (0 1 %IPADDR_NUM%) do (
    route add -p  !IPADDR[%%i]! mask 255.255.255.255 192.168.98.1
    rem set /a count=%%i
    rem cmd /k "route add -p  %%IPADDR[!count!]%% mask 255.255.255.255 192.168.98.1",两种写法均可，需要注意的是使用循环本身的变量作为数组索引，是现在的写法，使用新的变量，是注释中的写法。

    rem 使用注释掉的命令会报参数错误，起因:for循环中调用其他bat，会直接退出for循环，所以添加多条路由条目就无法完成，但是直接使用命令route而不是通过cmd调用的话，又会对后者的写法报参数错误
)
pause