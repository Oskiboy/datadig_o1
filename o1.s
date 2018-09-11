.thumb
.syntax unified

.include "gpio_constants.s"


.text
	.global Start


Start:
    bl      poll_button
    bne     turn_on_led
    bl     turn_off_led
    b Start


poll_button:
    ldr r0, =BUTTON_PORT
    ldr r1, =PORT_SIZE
    mul r0, r0, r1
    ldr r1, =GPIO_BASE
    add r0, r0, r1          //r0 now contains address of the button port
    ldr r1, =GPIO_PORT_DIN  //r1 contains the input bits offset
    ldr r3, [r0, r1]        //r3 now contains the input bits.
    
    mov r2, #1
    lsl r2, r2, #BUTTON_PIN //r2 contains the byte to or with the inputs to see if the button is pressed.

    and r0, r3, r2          //compare the input with the bit we want
    cmp r0, #0

    mov pc, lr              //go back to call location

turn_off_led:
    ldr r0, =PORT_E
    ldr r1, =PORT_SIZE
    mul r0, r0, r1
    ldr r1, =GPIO_BASE
    add r0, r0, r1

    mov r2, #1
    lsl r2, r2, #LED_PIN
    ldr r1, =GPIO_PORT_DOUTCLR
    str r2, [r0, r1]

    mov pc, lr

turn_on_led:
    ldr r0, =PORT_E
    ldr r1, =PORT_SIZE
    mul r0, r0, r1
    ldr r1, =GPIO_BASE
    add r0, r0, r1

    mov r2, #1
    lsl r2, r2, #LED_PIN
    ldr r1, =GPIO_PORT_DOUTSET
    str r2, [r0, r1]
    
    b Start

NOP // no touchey

