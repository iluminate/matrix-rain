#!/bin/bash
tput civis
trap 'tput cnorm; printf "\e[0m"; clear; exit' INT TERM EXIT

cols=$(tput cols)
rows=$(tput lines)

chars=(
  ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ
  ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ
  ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ
)
nc=${#chars[@]}

C0=$'\e[38;5;82m'
C1=$'\e[38;5;46m'
C2=$'\e[38;5;40m'
C3=$'\e[38;5;34m'
C4=$'\e[38;5;22m'

CSLOT=32
total=$(( cols * CSLOT ))

declare -a CC
for ((k = 0; k < total; k++)); do
  CC[$k]=${chars[$((RANDOM % nc))]}
done

for ((x = 0; x < cols; x++)); do
  H[$x]=$(( RANDOM % rows + rows ))
  LEN[$x]=$(( RANDOM % 8 + 20 ))
  SPD[$x]=$(( RANDOM % 3 + 2 ))
  CLK[$x]=$(( RANDOM % SPD[$x] ))
  DLY[$x]=$(( RANDOM % 30 ))
  CT[$x]=0
  CR[$x]=$(( RANDOM % 10 + 8 ))
done

printf "\e[2J\e[H\e[40m"
for ((r = 0; r < rows; r++)); do
  for ((c = 0; c < cols; c++)); do printf " "; done
done

while true; do
  buf="\e[?25l"

  for ((x = 0; x < cols; x++)); do

    if (( DLY[$x] > 0 )); then
      (( DLY[$x]-- ))
      continue
    fi

    L=${LEN[$x]}
    base=$(( x * CSLOT ))

    (( CT[$x]++ ))
    if (( CT[$x] >= CR[$x] )); then
      CT[$x]=0
      CR[$x]=$(( RANDOM % 10 + 8 ))
      CC[$(( base + RANDOM % CSLOT ))]=${chars[$((RANDOM % nc))]}
    fi

    # Avance
    (( CLK[$x]++ ))
    if (( CLK[$x] < SPD[$x] )); then
      continue
    fi
    CLK[$x]=0
    (( H[$x]++ ))

    hh=${H[$x]}

    head_row=$(( hh - rows ))

    if (( head_row >= rows )); then
      for ((r = 0; r < rows; r++)); do
        buf+="\e[$((r+1));$((x+1))H\e[40m "
      done
      H[$x]=$(( rows ))
      CLK[$x]=0
      LEN[$x]=$(( RANDOM % 8 + 20 ))
      SPD[$x]=$(( RANDOM % 3 + 2 ))
      DLY[$x]=$(( RANDOM % 15 ))
      CR[$x]=$(( RANDOM % 10 + 8 ))
      continue
    fi

    t1=$(( L / 10 ))
    t2=$(( L * 4 / 10 ))
    t3=$(( L * 7 / 10 ))

    if (( head_row >= 0 && head_row < rows )); then
      buf+="\e[$((head_row+1));$((x+1))H${C0}${CC[$base]}"
    fi

    for ((i = 1; i < L; i++)); do
      r=$(( head_row - i ))
      (( r < 0 || r >= rows )) && continue
      ci=$(( base + i % CSLOT ))
      if   (( i <= t1 )); then c=$C1
      elif (( i <= t2 )); then c=$C2
      elif (( i <= t3 )); then c=$C3
      else                     c=$C4
      fi
      buf+="\e[$((r+1));$((x+1))H${c}${CC[$ci]}"
    done

    tail_row=$(( head_row - L ))
    if (( tail_row >= 0 && tail_row < rows )); then
      buf+="\e[$((tail_row+1));$((x+1))H\e[40m "
    fi

  done

  printf "$buf"
  sleep 0.025
done