#!/bin/bash

usage() {
  cat <<EOF
Использование: $0 [опции]

Опции:
  -l, --level    Уровень RAID (по умолчанию 6)
  -n, --parts    Число разделов (по умолчанию 5)
  -h, --help     Показать это сообщение
EOF
  exit 1
}

RAID_LEVEL=6
NUM_PARTS=5

while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--level)
    RAID_LEVEL=$2
    shift 2
    ;;
    -n|--parts)
    NUM_PARTS = $2
    shift 2
    ;;
    -h|--help)
    usage
    ;;
  *)
  echo "Неизвестная опция: $1"
  usage
  ;;
esac
done


mdadm --zero-superblock --force /dev/sd{b,c,d,e,f};
mdadm --create --verbose /dev/md0 -l "$RAID_LEVEL" -n "$NUM_PARTS" /dev/sd{b,c,d,e,f};

sleep 15 # для дисков в 1 гб думаю более чем достаточно)))
cat /proc/mdstat 
