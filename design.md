# Space War
---
The player controls a space ship that can shoot different types of bullets.
The background is generated procedurally using perilyn noise.
The world extends infinitely in all sides.
There are space ships that have AI.
There are turrets.
There are buildings. 
There are satellites that shoot bullets.

# TODO
[] Speed is limited mouse position. So give a powerup to boost the speed
[] Add a settings section to enable fixed speed for left and right movement
[x] Add a settings section to chanage volume and mute the background music
[] Powerups
    [] 2x Speed
[] Power up counter

[] Guns
    [x] Normal Gun
    [] Double barrel
    [] Shot Gun
[] Player
    [] Health

# Collision Layers

1 - Common
2 - Player
3 - Enemy

# Check list for anything other than players
[] Free the resources if they are at a distance 10_000 from player
[] Use proper collision layer

# Thanks

background music - mixkit-to-the-next-round-1047.mp3 - To the Next Round by Michael Ramir C.

# Things learned

AudioStreamPlayer loops mp3 but AudioStreamPlayer2D won't