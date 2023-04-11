//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//
package mobilitysetup.simulations.manhattan;

import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.node.ethernet.Eth10G;

import simu5g.world.radio.LteChannelControl;
import simu5g.common.carrierAggregation.CarrierAggregation;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import simu5g.nodes.PgwStandard;
import simu5g.common.binder.Binder;
import simu5g.nodes.eNodeB;
import simu5g.nodes.cars.NRCar;

import simu5g.nodes.Upf;
import simu5g.nodes.mec.MECHost;
import simu5g.nodes.mec.MECOrchestrator.MecOrchestrator;
import simu5g.nodes.mec.UALCMP.UALCMP;
import simu5g.nodes.NR.gNodeB;
import simu5g.nodes.NR.NRUe;
import simu5g.nodes.backgroundCell.BackgroundCell;
import simu5g.world.radio.LteChannelControl;

import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;


network manhattan_network
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        //@display("bgb=1010,1010;bgi=manhttan");

    submodules:

        routingRecorder: RoutingTableRecorder {
            //@display("p=43.846157,373.07693;is=s");
            @display("p=2040.168,934.908");
        }

        configurator: Ipv4NetworkConfigurator {
            //@display("p=50,125");
            @display("p=2040.168,693.576");
        }

        //# Veins manager module
        veinsManager: VeinsInetManager {
            //@display("p=50,206.15385;is=s");
            @display("p=2040.168,811.2");
        }

        //# NR modules
        channelControl: LteChannelControl {
            //@display("p=49.23077,44.615387;is=s");
            @display("p=2174.0159,691.548");
        }
        binder: Binder {
            //@display("p=43.846157,457.69232;is=s");
            @display("p=2019.888,1194.492");
        }
        carrierAggregation: CarrierAggregation {
            //@display("p=43.846157,296.9231;is=s");
            @display("p=2001.636,1052.532");
        }




        //# MEC system
        mecOrchestrator: MecOrchestrator {
            @display("p=505,119");
        }
        ualcmp: UALCMP {
            @display("p=505,313");
        }
        upf: Upf {
            @display("p=505,448");
        }

        //# MEC sub-systems A, B, C....
        mecHost1: MECHost {
            @display("p=250,253");
        }
        gnb1: gNodeB {
            @display("p=250.00002,253.07693");
        }

        mecHost2: MECHost {
            @display("p=750,250");
        }
        gnb2: gNodeB {
            @display("p=750,250");
        }

        mecHost3: MECHost {
            @display("p=250,750");
        }
        gnb3: gNodeB {
            @display("p=250,750");
        }

        mecHost4: MECHost {
            @display("p=750,750");
        }
        gnb4: gNodeB {
            @display("p=750,750");
        }

        //# submodule vector to store all cars - will be filled dynamically during simulations
        car[0]: NRCar {

            @display("p=5463.432,1484.496;is=vl");
        }
    connections:
        //# 5g core
        //# upf.pppg++ <--> Eth10G <--> iUpf.pppg++;
        upf.pppg++ <--> Eth10G <--> gnb1.ppp;
        upf.pppg++ <--> Eth10G <--> gnb2.ppp;
        upf.pppg++ <--> Eth10G <--> gnb3.ppp;
        upf.pppg++ <--> Eth10G <--> gnb4.ppp;


        //# MEC-related connections
        ualcmp.ppp++ <--> Eth10G <--> upf.filterGate;
        ualcmp.toMecOrchestrator --> mecOrchestrator.fromUALCMP;
        ualcmp.fromMecOrchestrator <-- mecOrchestrator.toUALCMP;
        upf.pppg++ <--> Eth10G <--> ualcmp.ppp++;

        mecHost1.ppp++ <--> Eth10G <--> upf.pppg++;
        mecHost2.ppp++ <--> Eth10G <--> upf.pppg++;
        mecHost3.ppp++ <--> Eth10G <--> upf.pppg++;
        mecHost4.ppp++ <--> Eth10G <--> upf.pppg++;

        mecHost1.ppp++ <--> Eth10G <--> gnb1.pppMEHost;
        mecHost2.ppp++ <--> Eth10G <--> gnb2.pppMEHost;
        mecHost3.ppp++ <--> Eth10G <--> gnb3.pppMEHost;
        mecHost4.ppp++ <--> Eth10G <--> gnb4.pppMEHost;

        //# X2 connections
        gnb1.x2++ <--> Eth10G <--> gnb2.x2++;
        gnb1.x2++ <--> Eth10G <--> gnb3.x2++;
        gnb1.x2++ <--> Eth10G <--> gnb4.x2++;
        gnb2.x2++ <--> Eth10G <--> gnb3.x2++;
        gnb2.x2++ <--> Eth10G <--> gnb4.x2++;
        gnb3.x2++ <--> Eth10G <--> gnb4.x2++;
}
