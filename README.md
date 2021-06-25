# hot-server
I wrote this for an older Dell PowerSpec Server that I use. I'm sure it can be adapted to work on most any PC that has sensors.

The script is a little over complicated, as most things I do are, because I have it check every two minutes and if it's hot, but not dying, I don't want it to flood me with emails about it (especially if I'm offsite and can't do anything about it). Added script to shut it off before it explodes.

lm-sensors is required for this to work: 
```
sudo apt install lm-sensors
```
then
```
sudo sensors-detect
```
answer some questions and when you type `sensors`, you get something like this:
```bash
coretemp-isa-0000
Adapter: ISA adapter
Core 0:       +38.0°C  (high = +78.0°C, crit = +100.0°C)
Core 1:       +39.0°C  (high = +78.0°C, crit = +100.0°C)
```
and...
```
sensors -f
```
will return something like this
```bash
coretemp-isa-0000
Adapter: ISA adapter
Core 0:       +98.6°F  (high = +172.4°F, crit = +212.0°F)
Core 1:      +100.4°F  (high = +172.4°F, crit = +212.0°F
```
then type `crontab -e` (no, not sudo, doesn't need sudo)
add:
```bash
*/2 * * * * /dir-you-put-it-in/temphot.sh
```
