./matrix_calculator.py --architecture gfx1100 --instruction "$1" --register-layout -"$2" --csv > /tmp/"$1".csv
sed -n '3,$p'  /tmp/"$1".csv > /tmp/mat.csv && mv /tmp/mat.csv /tmp/"$1".csv
python layout.py "$1"
