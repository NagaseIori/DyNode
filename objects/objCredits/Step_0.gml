
if(keycheck(vk_space))
    rollSpeedT = roll_speed * roll_speedup_factor;
else
    rollSpeedT = roll_speed;

rollSpeed = lerp_a(rollSpeed, rollSpeedT, 0.3);
nowY -= rollSpeed / room_speed;
