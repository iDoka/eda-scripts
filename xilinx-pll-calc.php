<?php

  /**
   * A PHP calculator for desired frequency by PLL/DCM onto Xilinx FPGA
   * @package 
   * @author  Dmitry Murzinov (kakstattakim@gmail.com)
   * @link :  https://github.com/iDoka/eda-scripts
   * @version 1.0
   */

                         #######################
  ########################                     #
  #                      #   Useful Folmulae   #
  #                M     #  for PLL Equation   #  
  #   Fvco = Fin * -     #                     #  
  #                D     #######################
  #                                         #
  #          Fvco                      M    #
  #   Fout = ----   or  Fout = Fin * -----  # 
  #            O                      D*O   #
  #                                         #
  ###########################################

  # Example of usage:
  #  $ php xilinx-pll-calc.php
  #

  $F_input    = 50e6; // Hz
  $F_desired  = 48e6; // Hz
  $precission = 0.5;    // %
  //$tolerance=1; //  %


  // check if CLI-mode
  if (PHP_SAPI != "cli") {
    exit;
  }

  define('__ROOT__', dirname(__FILE__));
  //require_once(__ROOT__.'/PLL-func.php');

/*
  // parsing arg as filename
  if ($argc > 1) {
    $filename = $argv[1];
    $contents = file_get_contents($filename);
    $contents = utf8_encode($contents);
    $pinout = json_decode($contents,TRUE);
  }
  else {
     echo "Usage tool in CLI:\n\t$ php xilinx-pll-calc.php\n";
     exit;
  }
*/
  
  ###########################################
  ### Store of settings different PLL

  $SPARTAN6 = array(              // -3 grade  -2 grade  -1L grade
       "FREQ_INP_MIN"  =>   19e6,
       "FREQ_INP_MAX"  =>  450e6, //   540        450       300
       "FREQ_VCO_MIN"  =>  400e6, 
       "FREQ_VCO_MAX"  => 1000e6, //  1080       1000      1000 
       "FREQ_OUT_MIN"  => 3.125e6, 
       "FREQ_OUT_MAX"  =>  950e6, //  1080        950       500 
       "M_MIN"  => 1, 
       "M_MAX"  => 64,     
       "D_MIN"  => 1, 
       "D_MAX"  => 128,
       "O_MIN"  => 1, 
       "O_MAX"  => 52);

  $VIRTEX7 = array(               // -3 grade  -2 grade  -1 grade
       "FREQ_INP_MIN"  =>   19e6,
       "FREQ_INP_MAX"  =>  800e6, //   1066       933       800
       "FREQ_VCO_MIN"  =>  800e6, 
       "FREQ_VCO_MAX"  => 1600e6, //   2133      1866      1600
       "FREQ_OUT_MIN"  => 6.25e6, 
       "FREQ_OUT_MAX"  =>  800e6, //   1066       933       800
       "M_MIN"  => 2, 
       "M_MAX"  => 64,     
       "D_MIN"  => 1, 
       "D_MAX"  => 128,
       "O_MIN"  => 1, 
       "O_MAX"  => 56);

  ###########################################

/*
Stages:
1. Check input range
2. Check output range
3. Pick up 3 cycles for proper Fvco and Fout with desired tolerance
4. If unsuccessful -> goto chain of 2 serial PLL connection
*/

  // Pick up desired FPGA family:
  $FPGA = $SPARTAN6;


  ########## 1. Check input range ##########
  if (($FPGA["FREQ_INP_MIN"] > $F_input) | ($FPGA["FREQ_INP_MAX"] < $F_input)) {
     echo "CAUTION: Input frequency out of range!".PHP_EOL;
     exit;
  }

  ########## 2. Check output range ##########
  if (($FPGA["FREQ_OUT_MIN"] > $F_desired) or ($FPGA["FREQ_OUT_MAX"] < $F_desired)) {
     echo "CAUTION: Output frequency out of range!".PHP_EOL;
     exit;
  }

  $tolerance = $precission / 100; // parts
  echo PHP_EOL."Settings:".PHP_EOL."\tFinput:  $F_input Hz".PHP_EOL."\tFoutput: $F_desired Hz (desired)".PHP_EOL.PHP_EOL;
  //echo "\e[7m  M\tD\tO    \tFout      (Error)\e[0m".PHP_EOL;
  echo "\e[7m  M     D       O        Fout     (Error)\e[0m".PHP_EOL;
  echo "===== ===== ========= =========== =======".PHP_EOL;

  ########## 3. Pick up 3 cycles for proper Fvco and Fout with desired tolerance ##########
  for ($M=$FPGA["M_MIN"]; $M<=$FPGA["M_MAX"]; $M++) {
    for ($D=$FPGA["D_MIN"]; $D<=$FPGA["D_MAX"]; $D++) {
      $F_VCO = $F_input * $M/$D;
      if (($FPGA["FREQ_VCO_MIN"] <= $F_VCO) and ($FPGA["FREQ_VCO_MAX"] >= $F_VCO)) {
        //echo "M=$M \tD=$D \tVCO=$F_VCO".PHP_EOL;
        for ($O=$FPGA["O_MIN"]; $O<=$FPGA["O_MAX"]; $O++) {
          $F_output = $F_input * $M/$D/$O;
          if ((($F_desired*(1-$tolerance)) <= $F_output) and ($F_output <= ($F_desired*(1+$tolerance)))) {
            $deviation = ceil(abs($F_output/$F_desired-1)*100*100)/100;
            if ($F_desired == $F_output) {
              echo "\e[1m\e[32m $M\t$D\t$O \t$F_output   bingo\e[0m".PHP_EOL;
            } else {  
              $F_output = round($F_output);
              echo " $M\t$D\t$O \t$F_output  ($deviation%)".PHP_EOL;
            }
          }
        }  
      } 
    }
  }



  ########## 4. chain of 2 serial PLL connection ##########

  # To do ...



###########################################################################################################
?>
