#!/bin/bash
# validfloat--Tests whether a number is a valid floating-point value.
#   Note that this script cannot accept scientific (1.304e5) notation.

# To test whether an entered value is a valid floating-point number, we
#   need to split the value into two parts: the integer portion
#   and the fractional portion. We can test the first part to see
#   if it's a valid integer, then test whether the second part is a 
#   valid >=0 integer. So -30.5 evaluates as valid, but -30.-8 doesn't.

# To include another shell script as part of this one, use the "." source 
#   notation. Easy enough.

. validint   # Bourne shell notation to source the validint function

validfloat()
{
  fvalue="$1"

  # Check whether the input number has a decimal point.
  if [ ! -z $(echo $fvalue | sed 's/[^.]//g') ] ; then

    # Extract the part before the decimal point (like the '3' in '3.14').
    decimalPart="$(echo $fvalue | cut -d. -f1)"

    # And the digits after the decimal point (the '14' in '3.14').
    fractionalPart="${fvalue#*\.}"

    # Let's start by testing the decimal part, which is 
    #   everything to the left of the decimal point.

    if [ ! -z $decimalPart ] ; then
      # "!" reverses test logic, so the following is 
      #   "if NOT a valid integer"
      if ! validint "$decimalPart" "" "" ; then
        return 1
      fi 
    fi

    # Now let's test the factional (right of decimal point) value.
    # To start, you can't have a negative sign after the decimal point 
    #   like 33.-11, so let's test for the '-' sign in the decimal.
    if [ "${fractionalPart%${fractionalPart#?}}" = "-" ] ; then
      echo "Invalid floating-point number: '-' not allowed \
        after decimal point" >&2         # >&2 sends output to stderr.
      return 1
    fi 
    if [ "$fractionalPart" != "" ] ; then 
      # If the fractional part is NOT a valid integer...
      if ! validint "$fractionalPart" "0" "" ; then
        return 1
      fi
    fi
  else 
    # If the entire value is just "-", that’s not good either.
    if [ "$fvalue" = "-" ] ; then
      echo "Invalid floating-point format." >&2 ; return 1
    fi

    # Finally, check that the remaining digits are actually 
    #   valid as integers.
    if ! validint "$fvalue" "" "" ; then
      return 1
    fi
  fi

  return 0
}

if validfloat $1 ; then
  echo "$1 is a valid floating-point value"
fi

#exit 0
