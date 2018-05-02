echo Mounting Virtual Drive
diskpart /s C:\cygwin\home\Nick\Breeze\mount.bat
echo Moving Kernel to Drive
del F:\kernel.sys
copy kernel.sys F:\
echo Unmounting
diskpart /s C:\cygwin\home\Nick\Breeze\unmount.bat
echo Finished
pause