# freq_div (module)

### Author : Foez Ahmed (foez.official@gmail.com)

## TOP IO
<img src="./freq_div_top.svg">

## Description

The `freq_div` module is a frequency divider with a configurable divisor.

When the divisor is 1 or 0, the frequency division is bypassed, and the output clock is the same as
the input clock. Otherwise, the frequency division is performed by counting the clock cycles and
toggling the output clock when the count reaches the high or low count threshold.

The frequency divider uses sequential logic to implement the frequency division. The sequential
logic is sensitive to the rising edge of the input clock and the falling edge of the reset signal.
When the reset signal is not asserted, the counter is incremented at each clock cycle, and the
output clock is toggled when the count reaches the high or low count threshold.

## Parameters
|Name|Type|Dimension|Default Value|Description|
|-|-|-|-|-|
|DIVISOR_SIZE|int||9|The size of the divisor register|

## Ports
|Name|Direction|Type|Dimension|Description|
|-|-|-|-|-|
|arst_ni|input|logic||The asynchronous global reset signal|
|divisor_i|input|logic [DIVISOR_SIZE-1:0]|| The clock divisor. It is a logic vector with a width of `DIVISOR_SIZE`|
|clk_i|input|logic||The input clock signal|
|clk_o|output|logic||The output clock signal|
