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

package mobilitysetup.simulations.highway;

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

network highway_network
{
    parameters:
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)

        //@display("bgb=1100,250;bgi=highway");

    submodules:

        routingRecorder: RoutingTableRecorder {
            //@display("p=10,10;is=s");
            @display("p=241.5,467.82");
        }

        configurator: Ipv4NetworkConfigurator {
            //@display("p=10,20");
            @display("p=59.34,361.56");
        }

        //# Veins manager module
        veinsManager: VeinsInetManager {
            //@display("p=10,30;is=s");
            @display("p=241.5,365.7");
        }

        //# NR modules
        channelControl: LteChannelControl {
            //@display("p=900,10;is=s");
            @display("p=142.14,360.18");
        }
        binder: Binder {
            //@display("p=900,20;is=s");
            @display("p=146.28,459.54");
        }
        carrierAggregation: CarrierAggregation {
            //@display("p=900,30;is=s");
            @display("p=59.34,459.54");
        }


        //# MEC system
        mecOrchestrator: MecOrchestrator {
            @display("p=606,192");
        }
        ualcmp: UALCMP {
            @display("p=500,192");
        }
        upf: Upf {
            @display("p=500,99");
        }

        //# MEC sub-systems A, B, C....
        mecHost1: MECHost {
            @display("p=241.5,151.8");
        }
        gnb1: gNodeB {
            @display("p=241.5,49.68");
        }

        mecHost2: MECHost {
            @display("p=749.33997,151.8");
        }
        gnb2: gNodeB {
            @display("p=750,50");
        }

        //# submodule vector to store all cars - will be filled dynamically during simulations
        car[0]: NRCar {


            @display("p=1631.16,235.98");
        }
    connections:
        //# 5g core
        //# upf.pppg++ <--> Eth10G <--> iUpf.pppg++;
        upf.pppg++ <--> Eth10G <--> gnb1.ppp;
        upf.pppg++ <--> Eth10G <--> gnb2.ppp;


        //# MEC-related connections
        ualcmp.ppp++ <--> Eth10G <--> upf.filterGate;
        ualcmp.toMecOrchestrator --> mecOrchestrator.fromUALCMP;
        ualcmp.fromMecOrchestrator <-- mecOrchestrator.toUALCMP;
        upf.pppg++ <--> Eth10G <--> ualcmp.ppp++;

        mecHost1.ppp++ <--> Eth10G <--> upf.pppg++;
        mecHost2.ppp++ <--> Eth10G <--> upf.pppg++;

        mecHost1.ppp++ <--> Eth10G <--> gnb1.pppMEHost;
        mecHost2.ppp++ <--> Eth10G <--> gnb2.pppMEHost;

        //# X2 connections
        gnb1.x2++ <--> Eth10G <--> gnb2.x2++;

}
