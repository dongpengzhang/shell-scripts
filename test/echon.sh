echon()
{
  echo "$*" | awk '{ printf "%s", $0 }'
}

echon2()
{
	printf "%s" "$*"
}

echon3()
{
	echo "$" | tr -d '\n'
}
