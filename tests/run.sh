cfilelist=$(ls -l | grep ".gbl" | awk '{print $9}')
for cfilename in $cfilelist
do
echo $cfilename
#cat $cfilename | ../microc.native > text.txt
cat $cfilename | ../microc.native > ${cfilename%%.*}'.py'
done
