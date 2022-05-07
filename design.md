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
[x] Add a settings section to chanage volume and mute the background music
[] Powerups
    [] 2x Speed
    [x] Health
    [] Armour
    [] Explode everything on the way
    [x] Double barrel ammo proper power up image
    [x] Missile Powerup
[] Power up counter

[] Guns
    [x] Normal Gun
    [x] Double barrel
    [x] Missile
    [] Laser Gun
[] Player
    [] Health bar
    [] Skew on sidewards movement


[] Environment
    [] Add blocks, housing turrets
    [] Satellites

[] Misc
 [x] Explosion
 [x] Explosion Sound

[] UI
    [] Bulletmeter

[] Procedural Logic
    [] Increase difficulty based on distance
    [] Spawn buildings


# Collision Layers

1 - Common
2 - Player
3 - Enemy
4 - 
5 - Powerup

# Check list for anything other than players
[] Free the resources if they are at a distance 10_000 from player
[] Use proper collision layer

# Thanks

background music - mixkit-to-the-next-round-1047.mp3 - To the Next Round by Michael Ramir C.

# Things learned

AudioStreamPlayer loops mp3 but AudioStreamPlayer2D won't