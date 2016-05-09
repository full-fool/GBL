cfilelist=$(ls -l | grep ".py" | awk '{print $9}')
for cfilename in $cfilelist
do
echo $cfilename
#cat $cfilename | ../microc.native > text.txt
#cat $cfilename | ../microc.native > ${cfilename%%.*}'.py'
python $cfilename > ${cfilename%%.*}'.out'
done
