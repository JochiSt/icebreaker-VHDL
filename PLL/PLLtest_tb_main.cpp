#include <iostream>
#include "PLLtest_tb.h"

using namespace std;

int main(){
    cxxrtl_design::p_testbench top;

    bool prev_led = 0;

    top.step();
    for(int cycle=0;cycle<1000;++cycle){

        top.p_clk.set<bool>(false);
        top.step();
        top.p_clk.set<bool>(true);
        top.step();

        bool cur_led = top.p_uut_2e_LED1.get<bool>();

        if (cur_led != prev_led){
            cout << "cycle " << cycle << " - led: " << cur_led << endl;
        }
        prev_led = cur_led;
    }
}
