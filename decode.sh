SIGN="RY_QP_2016"
KEY="RY_QP_MBCLIENT_!2016"

if [ $# != 1 ]; then
   echo "USE:./decode.sh path"
   exit 1
fi

IS_SINGLE_FILE=false

backup()
{
if [ x"$1" != x"." -a x"$1" != x".." ]; then
	if [ -d "$1" ]; then
		cp -r $1 $1"_backup"
	else
		local filePath=$1
		local fileName=${filePath%.*}
		local extension=${filePath##*.}
		if [ x"$extension" = x"luac" ]; then
			IS_SINGLE_FILE=true
		fi
	fi
fi
}

decrypt_file()
{
	local filePath=$1
	local fileName=${filePath%.*}
	local extension=${filePath##*.}
 	if [ x"$extension" = x"luac" ]; then
 	  ./lua_decrypt $filePath $fileName".lua" $SIGN $KEY

		if [ $IS_SINGLE_FILE != true ]; then
			rm -f $1
		fi
 	fi
}

decrypt_dir()
{
	for file in `ls -a $1`
	do
		if [ x"$file" != x"." -a x"$file" != x".." ]; then
			if [ -d "$1/$file" ]; then
				decrypt_dir "$1/$file"
			else
				decrypt_file "$1/$file"
			fi
		fi
	done
}

decrypt()
{
	if [ x"$1" != x"." -a x"$1" != x".." ]; then
		if [ -d "$1" ]; then
			decrypt_dir "$1"
		else
			decrypt_file "$1"
		fi
	fi
}

backup $1
decrypt $1
