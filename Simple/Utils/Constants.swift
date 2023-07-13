//
//  Constants.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/18/23.
//

import Firebase
import UIKit
import Foundation

// async call needs to be implemented later
// perhaps not because this is a global variable initializer, so variables will be initialized b4 any other code is executed

//func fetchArray<T: Decodable>(ofType type: T.Type, from urlString: String) async throws -> [T] {
//    let url = URL(string: urlString)!
//    let (data, _) = try await URLSession.shared.data(from: url)
//    return try JSONDecoder().decode([T].self, from: data)
//}

// emails specially allowed to have police account (police email domains are listed in "policesEmailDomains" variable)
let policesData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/polices.json")!)
let polices = try! JSONDecoder().decode([String].self, from: policesData)

//let polices =
//
//// emails specially allowed to have police account (police email domains are listed in "policesEmailDomains" variable)
//
//[
//    "ashin2022@gmail.com", // personal email. for developer's administrative use
//    "jjacks48@jhu.edu", // Jarron L Jackson, Baltimore Police Department
//    "rrule@chadwickschool.org", // Bob Rule, Chadwick School (Palos Verdes)
//    "thill@chadwickschool.org" // Ted Hill, Chadwick International (South Korea)
//]

// block reporting feature if too far from any local enforcement agencies (App Store protocol)
let policesLocationData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policesLocation.json")!)
let policesLocation = try! JSONDecoder().decode([[Double]].self, from: policesLocationData)
 
//let policesLocation =
//
//// block reporting feature if too far from any local enforcement agencies (App Store protocol)
//
//[
//    [42.33618904978958, -83.0570091573357], // Detroit Police Department
//    [32.50247796355152, -92.1105783819071], // Monroe Police Department
//    [35.16310836206498, -90.04771711732344], // Memphis Police Department
//    [37.21897381675602, -93.29065839146313], // Springfield Police Department
//    [38.63716645728471, -90.20722363915661], // Metropolitan Police Department - City of St. Louis
//    [35.10248538416908, -106.64785453928043], // Albuquerque Police Department
//    [61.2217053565378, -149.89602199592466], // Anchorage Police Department
//    [42.282260503625665, -89.10439505417109], // Rockford Police Department District
//    [39.29021636231264, -76.60750005886018], // Baltimore City Police Headquarters
//    [34.78490906008009, -92.2701688161913], // North Little Rock Police Department
//    [37.951411021197465, -121.29031185979407], // Stockton Police Department
//    [43.0568416018988, -87.91689459405991], // Milwaukee Police Department District 1 & Administration
//    [41.507900873123944, -81.69658644518985], // Cleveland Police Department
//    [37.801261320339194, -122.27498769984022], // Oakland Police Department
//    [43.43370352918128, -83.93519827919111], // Saginaw Police Department
//    [30.679351766349487, -88.09850032691755], // Mobile Police Department
//    [33.519774710057455, -86.81062306794455], // Birmingham Police Headquarters
//    [29.96413452364635, -90.09234581570821], // New Orleans Police Department
//    [32.50611508150963, -93.75637010795072], // Shreveport Police Department
//    [30.452000337747744, -91.08953385188812], // Baton Rouge Police Department
//    [39.11547550615816, -94.57150996216797], // The Kansas City Missouri Police Department
//    [39.96167113635259, -75.151339412732], // Philadelphia Police Department Headquarters
//    [40.01906493658933, -105.25009911459915], // Boulder Police Department
//    [37.352108542620826, -121.90600249899872], // San Jose Police Department
//    [39.78166032373341, -86.15575728139848], // Indianapolis Metropolitan Police Department - Headquarters
//    [33.70796590587893, -84.39726237311854], // Atlanta Police Department
//    [38.82931509836416, -104.82367131243059], // Colorado Springs Police Department
//    [33.801474790618656, -118.39193545336349], // Palos Verdes Estates Police
//    [37.40028383762512, 126.64472430741866], // Chadwick International School
//    [37.445836161467255, -122.1599503339293], // Palo Alto Police Department
//    [42.36854641936874, -71.08596587633414], // Cambridge Police Department
//    [41.82016595564011, -71.4204160234309], // Providence Police Department
//    [40.769788792971354, -73.98719734487035], // New York Police Dept
//    [41.30131226442872, -72.9207478014004], // New Haven Police Department
//    [40.360967783368956, -74.6648514597224], // Princeton Police Department
//    [41.716816440005424, -87.57007696897095], // Chicago Police Department
//    [34.15064361235137, -118.14472753808373], // Pasadena Police Department
//    [36.00450731922689, -78.8920500391587], // Durham Police Department Headquarters
//    [42.044406994594205, -87.68399202898154], // Evanston police department
//    [43.72010261813021, -72.2729260660494], // Hanover Police Department
//    [36.16359655873342, -86.77726383196021], // Central Police Precinct
//    [29.778678874086395, -95.37000526680501], // Houston Police Department - Central Patrol Station
//    [42.43718984075521, -76.49748523082167], // Ithaca Police Department
//    [41.70584972839761, -86.23505228851693], // Notre Dame Security Police
//    [37.87053971319033, -122.27332537299652], // Berkeley Police Department
//    [40.44876676099283, -79.97867694486568], // Pittsburgh Police Department Zone 2
//    [33.704156904151965, -84.39657572819559], // Atlanta Police Department
//    [42.28796193220635, -83.7454776769258], // Ann Arbor Police Department
//    [34.068849793547905, -118.24811481066884], // LAPD Headquarters
//    [34.09659522961133, -117.72243157339268], // Claremont Police Department
//    [38.98202688023768, -77.0107049904526], // Takoma Park Police Department
//    [43.91298122021331, -69.97578620193798], // Brunswick Police Department
//    [39.90181859103683, -75.34849262904774], // Swarthmore Borough Police Department
//    [35.49837153538033, -80.84993111383028], // Davidson Police Department
//    [42.30077494407272, -71.28801658294041], // Wellesley Police Department
//    [40.23401334777435, -80.65093726320038], // Beech Bottom Police Department
//    [42.37650620397115, -72.51738886148715], // Amherst Police Department
//    [44.01848513189801, -73.1723861712459], // Middlebury Police Department
//    [39.97613659396759, -75.30436741555371], // Haverford Twp Police Department
//    [42.305337587252474, -71.28855302243518], // Wellesley Police Department
//    [44.09413280956659, -70.2147878326207], // Lewiston Police Department
//    [43.10130494680025, -75.37387668714722], // Clinton Police Department
//    [44.56196758171688, -69.62840696460819], // Waterville Police Department
//    [41.56026475012024, -72.64925108852148], // Middletown Police Department
//    [41.74587640544292, -92.72849895782704], // Grinnell Police Department
//    [41.70809407412257, -73.92865663854276], // City of Poughkeepsie Police Department
//    [44.47862011399049, -93.17118866730658], // Northfield Police Department
//    [44.96048303514493, -93.08821901490899], // St. Paul Police Department
//    [42.3210304172938, -72.63204477373094], // Northampton Police Department
//    [38.97929582796948, -76.50640467325576], // Annapolis Police Department
//    [32.72830790322125, -117.14916650004004], // San Diego Police Headquarters
//    [51.50399981666908, -0.13042093186408507] // National Police Chiefs' Council
//]

// all officers with these email domains are regarded as police officers
// listed email domains from most dangerous cities + worst cities with mass shootings in the US
// https://theboutiqueadventurer.com/most-dangerous-cities-in-the-united-states/
// https://www.forbes.com/sites/laurabegleybloom/2023/01/31/most-dangerous-cities-in-the-us-crime-in-america/?sh=6ae421674b25
// search more email domains in Google: "neverbounce [city name] police department" (e.g. "neverbounce detroit police department")
let policesEmailDomainsData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/policesEmailDomains.json")!)
let policesEmailDomains = try! JSONDecoder().decode([String].self, from: policesEmailDomainsData)

//let policesEmailDomains =
//
//// all officers with these email domains are regarded as police officers
//// listed email domains from most dangerous cities + worst cities with mass shootings in the US
//// https://theboutiqueadventurer.com/most-dangerous-cities-in-the-united-states/
//// https://www.forbes.com/sites/laurabegleybloom/2023/01/31/most-dangerous-cities-in-the-us-crime-in-america/?sh=6ae421674b25
//// search more email domains in Google: "neverbounce [city name] police department" (e.g. "neverbounce detroit police department")
//
//[
//    "@detroitmi.gov", // Detroit, Michigan
//    "@detroitpoa.com",
//    "@ci.monroe.la.us", // Monroe, Louisiana
//    "@yourmpd.com",
//    "@memphistn.gov", // Memphis, Tennessee
//    "@memphispolice.org",
//    "springfieldmo.gov", // Springfield, Missouri
//    "@stlouiscountymo.gov", // St Louis, Missouri
//    "@stlouiscountypolice.com",
//    "@cabq.gov", // Albuquerque, New Mexico
//    "@nmapoa.com",
//    "@anchorageak.gov", // Anchorage, Alaska
//    "@alaskacops.org",
//    "@rockfordil.gov", // Rockford, Illinois
//    "@baltimorecity.gov", // Baltimore, Maryland
//    "@baltimorepolice.org",
//    "@baltimorecountymd.gov",
//    "@littlerock.gov", // Little Rock, Arkansas
//    "@nlrpolice.org",
//    "@stocktonca.gov", // Stockton, California
//    "@milwaukee.gov", // Milwaukee, Wisconsin
//    "@clevelandohio.gov", // Cleveland, Ohio
//    "@oaklandca.gov", // Oakland, California
//    "@saginaw-mi.com", // Saginaw, Michigan
//    "@mobilepd.org", // Mobile, Alabama
//    "@birminghamal.gov", // Birmingham, Alabama
//    "@nola.gov", // New Orleans, Louisiana
//    "@shreveportla.gov", // Shreveport, Louisiana
//    "@brla.gov", // Baton Rouge, Louisiana
//    "@kcpd.org", // Kansas City, Missouri
//    "@phila.gov", // Philadelphia, Pennsylvania
//    "@bouldercolorado.gov", // Boulder, Colorado
//    "@sjpd.org", // San Jose, California
//    "@sanjoseca.gov",
//    "@isp.IN.gov", // Indianapolis, Indiana
//    "@atlantaga.gov", // Atlanta, Georgia
//    "@coloradosprings.gov", // Colorado Springs, Colorado
//    "@pvestates.org", // Palos Verdes, California
//    "@lists.stanford.edu", // Stanford, California
//    "@cambridgepd.org", // Cambridge, Massachusetts
//    "cambridgema.gov",
//    "@providenceri.gov", // Providence, RI
//    "@nyc.gov", // New York, NY
//    "@newhavenct.gov", // 1 Union Ave, New Haven, CT 06519
//    "@princetonnj.gov", // 1 Valley Rd, Princeton, NJ 08540
//    "@chicagopolice.org", // 3510 S Michigan Ave, Chicago, IL 60653
//    "@cityofpasadena.net", // 207 Garfield Ave, Pasadena, CA 91101
//    "@durhamnc.gov", // 602 E Main St, Durham, NC 27701
//    "@cityofevanston.org", // 1454 Elmwood Ave, Evanston, IL 60201
//    "@hanoverboroughpa.gov", // 2011 W Lake St, Hanover Park, IL 60133
//    "@houstontx.gov", // 61 Riesner St, Houston, TX 77002
//    "@cityofithaca.org", // 120 E Clinton St, Ithaca, NY 14851
//    "@police.nd.edu", // Hammes Mowbray Hall, Notre Dame, IN 46556
//    "@berkeleyca.gov", // 2100 Martin Luther King Jr Way, Berkeley, CA 94704
//    "@pittsburghpa.gov", // 2000 Centre Ave, Pittsburgh, PA 15219
//    "@atlantapd.org", // 215 Lakewood Way SW, Atlanta, GA 30315
//    "@a2gov.org", // 301 E Huron St, Ann Arbor, MI 48104
//    "@lapdonline.org", // 100 W 1st St, Los Angeles, CA 90012
//    "@ci.claremont.ca.us", // 570 W Bonita Ave, Claremont, CA 91711
//    "@claremontpd.org",
//    "@takomaparkmd.gov", // 7500 Maple Ave, Takoma Park, MD 20912
//    "@brunswickmd.gov", // 85 Pleasant St, Brunswick, ME 04011
//    "@brunswickpolice.org",
//    "@swarthmorepa.org", // 121 Park Ave, Swarthmore, PA 19081
//    "@SwarthmorePD.org",
//    "@townofdavidson.org", // Actually fronts on Jackson Street, 216 S Main St, Davidson, NC 28036
//    "@wellesleyma.gov", // Wellesley College Rd, Wellesley, MA 02481
//    "@wvsp.gov", // 1315 Commerce St, Wellsburg, WV 26070
//    "@amherstma.gov", // 111 Main St, Amherst, MA 01002
//    "@townofmiddlebury.org", // 1 Lucius Shaw Ln, Middlebury, VT 05753
//    "@haverfordtownship.org", // 1010 Darby Rd, Havertown, PA 19083
//    "@lewistonmaine.gov", // 171 Park St, Lewiston, ME 04240
//    "@clintoncountygov.com", // Clinton, NY 13323
//    "@waterville-me.gov", // 10 Colby St, Waterville, ME 04901
//    "@middletownct.gov", // 222 Main St, Middletown, CT 06457
//    "@grinnelliowa.gov", // 1020 Spring St, Grinnell, IA 50112
//    "@cityofpoughkeepsie.com", // 62 Civic Center Plaza, Poughkeepsie, NY 12601
//    "@northfieldmn.gov", // 1615 Riverview Dr, Northfield, MN 55057
//    "@stpaul.gov", // 367 Grove St, St Paul, MN 55101
//    "@northamptonpd.com", // 29 Center St, Northampton, MA 01060
//    "@annapolis.gov", // 199 Taylor Ave, Annapolis, MD 21401
//    "@sandiego.gov", // 1401 Broadway, San Diego, CA 92101
//    "@npcc.police.uk" // 10 Victoria St, London SW1H 0NN, England
//]
 
// US universities are only catalogued so far (+ Chadwick community, JHMI)
// Both the police departments AND university domains (public safety officials) should be valid for police accounts
// https://github.com/Hipo/university-domains-list
let institutionalEmailDomainsData = try! Data(contentsOf: URL(string: "https://raw.githubusercontent.com/tlsgusdn1107/SIMPLE/main/Simple/Utils/institutionalEmailDomains.json")!)
let institutionalEmailDomains = try! JSONDecoder().decode([String].self, from: institutionalEmailDomainsData)

//let institutionalEmailDomains =
//
//policesEmailDomains
//
//+
//
//[
//    "@chadwickschool.org", "@jhmi.edu", "@meredith.edu", "@sunyrockland.edu", "@centralstate.edu", "@tocc.edu", "@hbu.edu", "@lbhc.edu", "@stcloudstate.edu", "@southeast.edu", "@student.ccm.edu", "@harford.edu", "@glendale.edu", "@columbia.edu", "@memphis.edu", "@highlandcc.edu", "@sunysullivan.edu", "@upb.pitt.edu", "@umuc.edu", "@su.edu", "@tacomacc.edu", "@schreiner.edu", "@ici.edu", "@iu.edu", "@wmitchell.edu", "@waldenu.edu", "@uh.edu", "@itt-tech.info", "@stolaf.edu", "@sc4.edu", "@cmc.edu", "@potsdam.edu", "@milligan.edu", "@woodbury.edu", "@hccfl.edu", "@kbcc.cuny.edu", "@mjc.edu", "@colin.edu", "@rhodesstate.edu", "@campbellsville.edu", "@somerset.kctcs.edu", "@rhodes.edu", "@neumann.edu", "@scsu.edu", "@northweststate.edu", "@nnc.edu", "@nd.edu", "@losrios.edu", "@malone.edu", "@tamuc.edu", "@lsc.edu", "@jcsu.edu", "@sagchip.edu", "@towson.edu", "@nemcc.edu", "@texascollege.edu", "@jamessprunt.edu", "@enmu.edu", "@paine.edu", "@niacc.edu", "@trcc.commnet.edu", "@cnm.edu", "@rccc.edu", "@hencc.kctcs.edu", "@roanoke.edu", "@nwtc.edu", "@goshen.edu", "@lincoln.edu", "@langston.edu", "@sunyjefferson.edu", "@mga.edu", "@cscc.edu", "@wlc.edu", "@calpoly.edu", "@geneseo.edu", "@indianatech.edu", "@conncoll.edu", "@metrostate.edu", "@midsouthcc.edu", "@mscfs.edu", "@mineralarea.edu", "@nunez.edu", "@nu.edu", "@clackamas.edu", "@umd.edu", "@eccc.edu", "@oxnardcollege.edu", "@jccmi.edu", "@minnesota.edu", "@uwf.edu", "@brescia.edu", "@savannahtech.edu", "@dartmouth.edu", "@chattanoogastate.edu", "@apus.edu", "@utsa.edu", "@ancollege.edu", "@clpccd.edu", "@trine.edu", "@uacch.edu", "@cityu.edu", "@devry.edu", "@ju.edu", "@uapb.edu", "@mvcc.edu", "@drakestate.edu", "@berklee.edu", "@saddleback.edu", "@jewell.edu", "@manor.edu", "@yu.edu", "@pitzer.edu", "@marietta.edu", "@aic.edu", "@wilberforce.edu", "@greenriver.edu", "@plattsburgh.edu", "@mendocino.edu", "@cccneb.edu", "@ozarka.edu", "@wilsoncc.edu", "@uaccb.edu", "@albemarle.edu", "@llcc.edu", "@baruch.cuny.edu", "@csuchico.edu", "@robertmorris.edu", "@gntc.edu", "@thunderbird.edu", "@friends.edu", "@bmhs.org", "@duke.edu", "@uwplatt.edu", "@hampshire.edu", "@mayland.edu", "@byuh.edu", "@morgancc.edu", "@curry.edu", "@pepperdine.edu", "@augustana.edu", "@ucla.edu", "@uvsc.edu", "@connorsstate.edu", "@vhcc.edu", "@barry.edu", "@southeast.kctcs.edu", "@seark.edu", "@csudh.edu", "@ascc.edu", "@tcu.edu", "@auburn.edu", "@mercer.edu", "@uab.edu", "@utah.edu", "@stevenscollege.edu", "@laverne.edu", "@wp.missouristate.edu", "@bakersfieldcollege.edu", "@mtholyoke.edu", "@honolulu.hawaii.edu", "@swtc.edu", "@ecok.edu", "@lehigh.edu", "@tnstate.edu", "@socc.edu", "@ntcc.edu", "@clovis.edu", "@louisiana.edu", "@winona.edu", "@maryvillecollege.edu", "@hcc.commnet.edu", "@spcc.edu", "@neit.edu", "@marin.edu", "@kettering.edu", "@wcjc.edu", "@iowacentral.edu", "@lsua.edu", "@bemidjistate.edu", "@anokaramsey.edu", "@lakeland.cc.il.us", "@morainevalley.edu", "@mwsc.edu", "@hvcc.edu", "@wiu.edu", "@kaskaskia.edu", "@odu.edu", "@oakwood.edu", "@lclark.edu", "@sjca.edu", "@nv.edu", "@waubonsee.edu", "@lander.edu", "@swmich.edu", "@monterey.edu", "@sautech.edu", "@vccs.edu", "@hmc.edu", "@g.hmc.edu", "@qcc.cuny.edu", "@mcad.edu", "@molloy.edu", "@sou.edu", "@swtjc.net", "@octech.edu", "@westkentucky.kctcs.edu", "@uci.edu", "@wesley.edu", "@alamo.edu", "@asurams.edu", "@ollusa.edu", "@matsu.alaska.edu", "@whitworth.edu", "@coe.edu", "@sanjuancollege.edu", "@oru.edu", "@otc.edu", "@cvcc.vccs.edu", "@alfredtech.edu", "@benedict.edu", "@yc.yccd.edu", "@inverhills.edu", "@ucdavis.edu", "@flcc.edu", "@witcc.edu", "@humboldt.edu", "@osu.edu", "@sbc.edu", "@manhattantech.edu", "@piercecollege.edu", "@lonestar.edu", "@utb.edu", "@wccs.edu", "@angelina.edu", "@mrs.umn.edu", "@coahomacc.edu", "@sl.psu.edu", "@sccnc.edu", "@tabor.edu", "@windward.hawaii.edu", "@cerritos.edu", "@mit.edu", "@depaul.edu", "@uc.edu", "@tridenttech.edu", "@coker.edu", "@lsco.edu", "@floridapoly.edu", "@bishop.edu", "@calhoun.edu", "@urbancollege.edu", "@ecu.edu", "@centralaz.edu", "@nwacc.edu", "@asnuntuck.edu", "@cooper.edu", "@heidelberg.edu", "@npc.edu", "@cmcc.edu", "@briar-cliff.edu", "@sckans.edu", "@bartonccc.edu", "@ivcc.edu", "@colby.edu", "@averett.edu", "@augie.edu", "@southside.edu", "@findlay.edu", "@shawu.edu", "@wtamu.edu", "@kirtland.edu", "@iusb.edu", "@du.edu", "@stjohns.edu", "@antiochne.edu", "@tunxis.edu", "@antioch.edu", "@wiltech.edu", "@lauruscollege.edu", "@aii.edu", "@moreheadstate.edu", "@wooster.edu", "@siskiyous.edu", "@ivc.edu", "@lmu.edu", "@case.edu", "@pratt.edu", "@vsu.edu", "@byui.edu", "@swac.edu", "@ohsu.edu", "@uwosh.edu", "@rider.edu", "@saintjoe.edu", "@ppcc.edu", "@njc.edu", "@mccc.edu", "@lamar.edu", "@oakton.edu", "@kzoo.edu", "@nau.edu", "@okstate.edu", "@tamiu.edu", "@roanokechowan.edu", "@montcalm.edu", "@depauw.edu", "@mcdowelltech.edu", "@gaston.edu", "@asu.edu", "@madisonville.kctcs.edu", "@waynecc.edu", "@udel.edu", "@augustatech.edu", "@ccbc.edu", "@kennesaw.edu", "@harding.edu", "@clarion.edu", "@wmcc.edu", "@mchenry.edu", "@colorado.edu", "@northeast.edu", "@scripps.edu", "@csun.edu", "@umflint.edu", "@stetson.edu", "@fullerton.edu", "@arizona.edu", "@blackrivertech.edu", "@colbycc.edu", "@lfc.edu", "@umm.maine.edu", "@messiah.edu", "@hope.edu", "@kpc.alaska.edu", "@wosc.edu", "@dominican.edu", "@lakeareatech.edu", "@rochester.edu", "@shastacollege.edu", "@jccc.edu", "@stedwards.edu", "@nic.edu", "@tbcc.cc.or.us", "@gbcnv.edu", "@uml.edu", "@cwc.edu", "@niagara.edu", "@stockton.edu", "@morehouse.edu", "@necc.edu", "@fullsail.edu", "@ulm.edu", "@raritanval.edu", "@laccd.edu", "@touro.edu", "@wmpenn.edu", "@uopeople.edu", "@pasadena.edu", "@suno.edu", "@illinois.edu", "@cochise.edu", "@ati.osu.edu", "@fordham.edu", "@western.edu", "@gwinnetttech.edu", "@mbc.edu", "@umr.edu", "@pccua.edu", "@uiowa.edu", "@nicc.edu", "@dakotacollege.edu", "@tarleton.edu", "@shsu.edu", "@littlehoop.edu", "@hssu.edu", "@rose.edu", "@rsu.edu", "@clevelandstatecc.edu", "@vanderbilt.edu", "@merritt.edu", "@reedleycollege.edu", "@sjcsf.edu", "@bmcc.cuny.edu", "@seattlecentral.edu", "@caltech.edu", "@utmb.edu", "@pfw.edu", "@anc.edu", "@strose.edu", "@lassencollege.edu", "@roguecc.edu", "@tesu.edu", "@jeffco.edu", "@bhc.edu", "@escc.edu", "@uchaswv.edu", "@kutztown.edu", "@ccnn.edu", "@sunyit.edu", "@fscj.edu", "@msmc.edu", "@ut.edu", "@rockefeller.edu", "@es.vccs.edu", "@dowling.edu", "@lltc.edu", "@bscc.edu", "@cgcc.cc.or.us", "@lavc.edu", "@missouri.edu", "@sfcpa.edu", "@pcom.edu", "@nvcc.edu", "@tuskegee.edu", "@bowiestate.edu", "@sjsu.edu", "@unc.edu", "@wichita.edu", "@smithseminary.org", "@westliberty.edu", "@monroecc.edu", "@unm.edu", "@wwcc.wy.edu", "@ramapo.edu", "@eastern.wvnet.edu", "@fvcc.edu", "@sheltonstate.edu", "@sage.edu", "@msubillings.edu", "@gateway.kctcs.edu", "@upmc.com", "@emc.maricopa.edu", "@davidson.edu", "@bu.edu", "@manc.edu", "@yosemite.edu", "@ric.edu", "@southwestern.edu", "@morris.edu", "@mursuky.edu", "@tccd.edu", "@iastate.edu", "@jacksonville-college.edu", "@lsu.edu", "@robeson.edu", "@sdsmt.edu", "@kysu.edu", "@nmcc.edu", "@armstrong.edu", "@washjeff.edu", "@gatech.edu", "@vmi.edu", "@trincoll.edu", "@ogeecheetech.edu", "@fpctx.edu", "@gtc.edu", "@acofi.edu", "@ccbcmd.edu", "@uncg.edu", "@wayne.uakron.edu", "@kumc.edu", "@btc.ctc.edu", "@jbu.edu", "@genesee.edu", "@cau.edu", "@usuhs.mil", "@fhsu.edu", "@uis.edu", "@maccormac.edu", "@ashland.kctcs.edu", "@ndus.edu", "@lee.edu", "@hoodseminary.edu", "@yti.edu", "@belmontcollege.edu", "@usiu.edu", "@egcc.edu", "@grcc.edu", "@plu.edu", "@ccm.edu", "@uor.edu", "@hocking.edu", "@coffeyville.edu", "@wvstate.edu", "@letu.edu", "@vcsu.nodak.edu", "@corning-cc.edu", "@mtech.edu", "@dcad.edu", "@calsouthern.edu", "@harvard.edu", "@baycollege.edu", "@midmich.edu", "@arapahoe.edu", "@wetcc.edu", "@lamission.edu", "@mmc.edu", "@iwcc.edu", "@providence.edu", "@elmhurst.edu", "@foothill.edu", "@shorter.edu", "@tui.edu", "@ltcc.edu", "@njcu.edu", "@wc.edu", "@acs350.org", "@luzerne.edu", "@linfield.edu", "@valleycollege.edu", "@highland.edu", "@morton.edu", "@unomaha.edu", "@ccu.edu", "@mst.edu", "@bvu.edu", "@mdc.edu", "@venturacollege.edu", "@msmary.edu", "@csbsju.edu", "@isothermal.edu", "@lesley.edu", "@columbiabasin.edu", "@vassar.edu", "@brookdalecc.edu", "@dc3.edu", "@ocean.edu", "@clevelandcc.edu", "@azwestern.edu", "@columbusstate.edu", "@panola.edu", "@netc.edu", "@villanova.edu", "@usfca.edu", "@mccd.edu", "@csusm.edu", "@hilo.hawaii.edu", "@bc.edu", "@mnwest.edu", "@keene.edu", "@suscc.edu", "@calarts.edu", "@bennet.edu", "@hartford.edu", "@loyola.edu", "@blackhawk.edu", "@simons-rock.edu", "@colostate.edu", "@geneva.edu", "@alcorn.edu", "@stthom.edu", "@cabrillo.edu", "@htu.edu", "@nr.edu", "@cofc.edu", "@cgs.edu", "@rmcc.edu", "@grace.edu", "@gwu.edu", "@smc.edu", "@csc.edu", "@seattleu.edu", "@ladelta.edu", "@redlandscc.edu", "@grossmont.edu", "@lakelandcc.edu", "@northern.edu", "@sdcc.edu", "@monroecollege.edu", "@sewanee.edu", "@urich.edu", "@cloud.edu", "@xula.edu", "@bigsandy.kctcs.edu", "@hawaii.hawaii.edu", "@pvcc.edu", "@ung.edu", "@adelphi.edu", "@swcciowa.edu", "@mpcc.edu", "@holycross.edu", "@trinity.edu", "@lindenwood.edu", "@zanestate.edu", "@csulb.edu", "@hartwick.edu", "@swmed.edu", "@spscc.ctc.edu", "@msm.edu", "@furman.edu", "@olemiss.edu", "@uidaho.edu", "@tvcc.cc", "@mcm.edu", "@anselm.edu", "@bridgemont.edu", "@coastalalabama.edu", "@utica.edu", "@rivervalley.edu", "@chatfield.edu", "@iavalley.edu", "@usao.edu", "@etbu.edu", "@www.sunyacc.edu", "@carrollcc.edu", "@austincollege.edu", "@columbiasc.edu", "@usna.edu", "@rcc.edu", "@wlu.edu", "@lccc.edu", "@dacc.edu", "@pacificu.edu", "@rustcollege.edu", "@king.edu", "@reynolds.edu", "@eicc.edu", "@pittstate.edu", "@gadsenstate.edu", "@troy.edu", "@trinitydc.edu", "@massasoit.edu", "@regent.edu", "@pima.edu", "@gcc.mass.edu", "@warren.edu", "@bcm.edu", "@haskell.edu", "@eosc.edu", "@wgu.edu", "@ambassador.edu", "@hartnell.edu", "@juniata.edu", "@indstate.edu", "@uta.edu", "@st-aug.edu", "@blinn.edu", "@kvctc.edu", "@berkshirecc.edu", "@jsums.edu", "@okbu.edu", "@baylor.edu", "@niagaracc.suny.edu", "@defiance.edu", "@haverford.edu", "@ucr.edu", "@ups.edu", "@lowercolumbia.edu", "@usi.edu", "@lagrange.edu", "@trinidadstate.edu", "@stanly.edu", "@spokanefalls.edu", "@kvcc.edu", "@umsl.edu", "@brockport.edu", "@psu.edu", "@gettysburg.edu", "@ku.edu", "@cowley.edu", "@scc.losrios.edu", "@cvtc.edu", "@mercy.edu", "@everest.edu", "@ridgewater.edu", "@georgetown.edu", "@mmm.edu", "@una.edu", "@ccsn.edu", "@unca.edu", "@upmc.edu", "@howardcollege.edu", "@vcc.edu", "@westminster.edu", "@sacramento.mticollege.edu", "@cecil.edu", "@ncsu.edu", "@southeastmissourihospitalcollege.edu", "@hiram.edu", "@lyndonstate.edu", "@uwgb.edu", "@aamu.edu", "@salisbury.edu", "@iowalakes.edu", "@msudenver.edu", "@pennhighlands.edu", "@gac.edu", "@cshl.edu", "@chesapeake.edu", "@sacredheart.edu", "@tri-c.edu", "@bpcc.edu", "@ewu.edu", "@thomasmore.edu", "@upj.pitt.edu", "@und.edu", "@denmarktech.edu", "@uiw.edu", "@hennepintech.edu", "@lhup.edu", "@ewc.wy.edu", "@coastalpines.edu", "@sinclair.edu", "@waynesburg.edu", "@msun.edu", "@ou.edu", "@unlv.edu", "@sans.edu", "@rccd.edu", "@sct.edu", "@richland.edu", "@chatham.edu", "@gallaudet.edu", "@worwic.edu", "@sscc.edu", "@calcoast.edu", "@claremontmckenna.edu", "@kbocc.org", "@dwu.edu", "@pierce.ctc.edu", "@bmcc.edu", "@canadacollege.edu", "@edgecombe.edu", "@capecod.edu", "@goldenwestcollege.edu", "@sic.edu", "@usu.edu", "@swri.edu", "@coto.edu", "@uwec.edu", "@unf.edu", "@yc.edu", "@pstcc.edu", "@agnesscott.edu", "@mesalands.edu", "@tayloru.edu", "@stkate.edu", "@graceland.edu", "@csufresno.edu", "@asub.edu", "@wm.edu", "@jfku.edu", "@wtc.edu", "@cwidaho.cc", "@stmarys-ca.edu", "@fkcc.edu", "@laniertech.edu", "@cravencc.edu", "@berkeley.edu", "@nmsua.edu", "@vfmac.edu", "@clarku.edu", "@pamlicocc.edu", "@jhuapl.edu", "@portervillecollege.edu", "@solacc.edu", "@cobleskill.edu", "@iecc.edu", "@trinitybiblecollege.edu", "@bluegrass.kctcs.edu", "@rmwc.edu", "@cedarville.edu", "@shawneecc.edu", "@mctc.edu", "@dscc.edu", "@allencol.edu", "@minotstateu.edu", "@ohio.edu", "@thomas.edu", "@taftu.edu", "@dctc.edu", "@assumption.edu", "@kvcc.me.edu", "@cccd.edu", "@sjvc.edu", "@cccti.edu", "@camdencc.edu", "@ius.edu", "@bellevuecollege.edu", "@ewc.edu", "@ggc.edu", "@prescott.edu", "@dupage.edu", "@cerrocoso.edu", "@uscga.edu", "@sagu.edu", "@wma.edu", "@barnard.edu", "@pomona.edu", "@umb.edu", "@gwcc.commnet.edu", "@dcc.edu", "@uwsp.edu", "@pgcc.edu", "@willistonstate.edu", "@ltu.edu", "@umpqua.edu", "@elcamino.edu", "@bennington.edu", "@coloradocollege.edu", "@fandm.edu", "@barstow.edu", "@dickinson.edu", "@uic.edu", "@uiu.edu", "@uga.edu", "@yvcc.edu", "@tcc.edu", "@coloradotech.edu", "@longwood.edu", "@jwu.edu", "@chaminade.edu", "@beaufortccc.edu", "@purduecal.edu", "@evc.edu", "@cos.edu", "@com.edu", "@umc.edu", "@philau.edu", "@stanford.edu", "@howardcc.edu", "@dordt.edu", "@sunydutchess.edu", "@gtcc.edu", "@scc.spokane.edu", "@roosevelt.edu", "@marshall.edu", "@mesabirange.edu", "@huntington.edu", "@chaffey.edu", "@cup.edu", "@santarosa.edu", "@bloomu.edu", "@syr.edu", "@pti.edu", "@uasys.edu", "@northampton.edu", "@wncc.edu", "@ccsf.edu", "@liberty.edu", "@pace.edu", "@unco.edu", "@winthrop.edu", "@clarke.edu", "@ithaca.edu", "@uni.edu", "@pnw.edu", "@yale.edu", "@elac.edu", "@erau.edu", "@tamuk.edu", "@sdsu.edu", "@fortlewis.edu", "@alliant.edu", "@usmma.edu", "@gsu.edu", "@occc.edu", "@brcc.edu", "@trcc.edu", "@farmingdale.edu", "@sdstate.edu", "@lemoyne.edu", "@muskegoncc.edu", "@reed.edu", "@mnstate.edu", "@mayo.edu", "@fairmontstate.edu", "@utd.edu", "@wisc.edu", "@cuc.edu", "@lrsc.edu", "@cedarvalleycollege.edu", "@pwsc.alaska.edu", "@rlc.edu", "@cptc.edu", "@rangercollege.edu", "@clinton.edu", "@wright.edu", "@siu.edu", "@brynmawr.edu", "@captechu.edu", "@uccs.edu", "@lyon.edu", "@gsw.edu", "@herkimer.edu", "@forsythtech.edu", "@uno.edu", "@nmjc.edu", "@hamilton.edu", "@westal.edu", "@ccri.edu", "@harrisburg.psu.edu", "@easternct.edu", "@montclair.edu", "@shu.edu", "@rit.edu", "@smcm.edu", "@savannahstate.edu", "@ccd.edu", "@coastal.edu", "@lehman.cuny.edu", "@mines.edu", "@nacc.edu", "@nlu.edu", "@uwstout.edu", "@compton.edu", "@css.edu", "@suu.edu", "@flc.losrios.edu", "@uiwtx.edu", "@fit.edu", "@dbu.edu", "@cacc.edu", "@hostos.cuny.edu", "@pointpark.edu", "@ugf.edu", "@montgomery.edu", "@uaccm.edu", "@edcc.edu", "@hagerstowncc.edu", "@brandman.edu", "@hood.edu", "@mcc.edu", "@amercoastuniv.edu", "@cincinnatistate.edu", "@callutheran.edu", "@gccnj.edu", "@valenciacollege.edu", "@solano.edu", "@westerntc.edu", "@ncktc.edu", "@nwcc.commnet.edu", "@pbac.edu", "@mscok.edu", "@nwfsc.edu", "@lasc.edu", "@northwestern.edu", "@huntingdon.edu", "@elgin.edu", "@student.scad.edu", "@alaskapacific.edu", "@stratford.edu", "@itascacc.edu", "@niu.edu", "@itc.edu", "@sru.edu", "@bristolcc.edu", "@daytonastate.edu", "@cocc.edu", "@bucks.edu", "@stevenson.edu", "@umsystem.edu", "@gotoltc.edu", "@dmu.edu", "@oakland.edu", "@sfcc.edu", "@westminster-mo.edu", "@westmont.edu", "@simpson.edu", "@gulfcoast.edu", "@cuny.edu", "@polk.edu", "@clayton.edu", "@riv.edu", "@ucsc.edu", "@durhamtech.edu", "@manhattan.edu", "@dickinsonstate.edu", "@nwmissouri.edu", "@foxcollege.edu", "@wmich.edu", "@uop.edu", "@neosho.edu", "@semo.edu", "@kilgore.edu", "@blueridge.edu", "@sullivan.edu", "@delmar.edu", "@tju.edu", "@wpi.edu", "@linnbenton.edu", "@hsc.edu", "@muskingum.edu", "@bccc.edu", "@oxy.edu", "@odessa.edu", "@hollins.edu", "@indwes.edu", "@lynchburg.edu", "@umw.edu", "@sjcc.edu", "@lackawanna.edu", "@citruscollege.edu", "@uark.edu", "@carteret.edu", "@ufl.edu", "@wellesley.edu", "@msdelta.edu", "@southwest.tn.edu", "@smccd.edu", "@csn.edu", "@prcc.edu", "@oswego.edu", "@4cd.edu", "@brenau.edu", "@marionmilitary.edu", "@monmouthcollege.edu", "@princeton.edu", "@hibbing.edu", "@wesleyan.edu", "@tiffin.edu", "@southwestgatech.edu", "@avila.edu", "@sdmesa.edu", "@eac.edu", "@keiseruniversity.edu", "@mstc.edu", "@dliflc.edu", "@clinch.edu", "@csum.edu", "@stevens.edu", "@jarvis.edu", "@usm.edu", "@msbcollege.edu", "@seattleantioch.edu", "@cayuga-cc.edu", "@coastalcarolina.edu", "@laspositascollege.edu", "@lccc.wy.edu", "@mtu.edu", "@miracosta.edu", "@labette.edu", "@gram.edu", "@broward.edu", "@alleg.edu", "@lamarcc.edu", "@triton.edu", "@mxcc.commnet.edu", "@westga.edu", "@transy.edu", "@southeastmn.edu", "@talladega.edu", "@sandiego.edu", "@etsu.edu", "@fsw.edu", "@uwyo.edu", "@unl.edu", "@daltonstate.edu", "@unt.edu", "@wpunj.edu", "@southark.edu", "@deltacollege.edu", "@digipen.edu", "@umich.edu", "@phillips.edu", "@lipscomb.edu", "@skagit.edu", "@rmc.edu", "@svsu.edu", "@southeasttech.edu", "@lasalle.edu", "@sdmiramar.edu", "@massasoit.mass.edu", "@etown.edu", "@rutgers.edu", "@uiuc.edu", "@nhcc.edu", "@hawaii.edu", "@atc.edu", "@tufts.edu", "@pulaskitech.edu", "@wcslc.edu", "@usc.edu", "@pinetech.edu", "@sbuniv.edu", "@nccc.edu", "@mccneb.edu", "@smcsc.edu", "@cua.edu", "@wjc.edu", "@germanna.edu", "@bastyr.edu", "@src.edu", "@csmd.edu", "@sonoma.edu", "@anokatech.edu", "@aquinas.edu", "@stcl.edu", "@cn.edu", "@scciowa.edu", "@mvc.edu", "@sscok.edu", "@mesacc.edu", "@jbc.edu", "@uwlax.edu", "@ecpi.edu", "@palmbeachstate.edu", "@wmwoods.edu", "@arc.losrios.edu", "@wdt.edu", "@ncta.unl.edu", "@fdu.edu", "@monroeccc.edu", "@hindscc.edu", "@garrettcollege.edu", "@iub.edu", "@kent.edu", "@tvcc.edu", "@boisestate.edu", "@csus.edu", "@cavern.nmsu.edu", "@piedmontcc.edu", "@cv.edu", "@eiu.edu", "@kckcc.edu", "@uchastings.edu", "@atu.edu", "@mgccc.edu", "@lawrence.edu", "@wallace.edu", "@jeffstateonline.com", "@huntingtonjuniorcollege.edu", "@monmouth.edu", "@iwu.edu", "@warren-wilson.edu", "@ncstatecollege.edu", "@stlawu.edu", "@parisjc.edu", "@uwsa.edu", "@uwc.edu", "@oberlin.edu", "@stmartin.edu", "@midwestern.edu", "@arcadia.edu", "@navarrocollege.edu", "@cheyney.edu", "@muc.edu", "@prairiestate.edu", "@american.edu", "@yorktech.edu", "@bible.edu", "@dtcc.edu", "@cameron.edu", "@summitunivofla.edu", "@cdkc.edu", "@fisk.edu", "@ncf.edu", "@mclennan.edu", "@wustl.edu", "@ucc.edu", "@jhu.edu", "@frederick.edu", "@southcentral.edu", "@hawkeyecollege.edu", "@westgatech.edu", "@stonybrookmedicine.edu", "@kcc.edu", "@oc.edu", "@csustan.edu", "@bridgewater.edu", "@sunymaritime.edu", "@holmescc.edu", "@uvi.edu", "@iccms.edu", "@atlantatech.edu", "@selmauniversity.edu", "@illinoisstate.edu", "@mcpherson.edu", "@coloradomesa.edu", "@swic.edu", "@utep.edu", "@dccc.edu", "@northgatech.edu", "@marquette.edu", "@washcoll.edu", "@einsteinmed.edu", "@richlandcollege.edu", "@swarthmore.edu", "@witc.edu", "@pnc.edu", "@smith.edu", "@napavalley.edu", "@hallmarkuniversity.edu", "@deanza.edu", "@ws.edu", "@otterbein.edu", "@saintleo.edu", "@utsouthwestern.edu", "@benedictine.edu", "@fplc.edu", "@imperial.edu", "@normandale.edu", "@iit.edu", "@bismarckstate.edu", "@castleton.edu", "@lr.edu", "@dmacc.edu", "@surry.edu", "@usa.edu", "@emmanuel.edu", "@roanestate.edu", "@aacc.edu", "@wmc.edu", "@luther.edu", "@citytech.cuny.edu", "@coastalbend.edu", "@sccollege.edu", "@sunycentral.edu", "@msjc.edu", "@usf.edu", "@ncmich.edu", "@sc.edu", "@rosary.edu", "@ntcmn.edu", "@rockhurst.edu", "@auc.edu", "@jmu.edu", "@wcupa.edu", "@csi.edu", "@volstate.edu", "@cookman.edu", "@gcccks.edu", "@alverno.edu", "@widener.edu", "@louisville.edu", "@missioncollege.edu", "@gcu.edu", "@faulknerstate.edu", "@unr.edu", "@hancockcollege.edu", "@lockhaven.edu", "@necc.mass.edu", "@smcvt.edu", "@shoreline.edu", "@martincc.edu", "@mccnh.edu", "@wheaton.edu", "@nmu.edu", "@wabash.edu", "@maine.edu", "@bcc.cuny.edu", "@clark.edu", "@saintmarys.edu", "@hillsdale.edu", "@elcentrocollege.edu", "@dillard.edu", "@tmcc.edu", "@pcc.edu", "@aum.edu", "@msoe.edu", "@essex.edu", "@ualr.edu", "@cccua.edu", "@pvamu.edu", "@ldsbc.edu", "@ccsnh.edu", "@northark.edu", "@bsu.edu", "@mhcc.edu", "@clintoncollege.edu", "@truman.edu", "@ggu.edu", "@northlandcollege.edu", "@brandeis.edu", "@ghc.edu", "@umaryland.edu", "@umassd.edu", "@umaine.edu", "@fredonia.edu", "@ncwc.edu", "@earlham.edu", "@ccac.edu", "@denison.edu", "@pacific.edu", "@victoriacollege.edu", "@fielding.edu", "@slcc.edu", "@fontbonne.edu", "@valpo.edu", "@mybrcc.edu", "@rctc.edu", "@losmedanos.edu", "@easternflorida.edu", "@drew.edu", "@hutchcc.edu", "@lssu.edu", "@smsu.edu", "@mpc.edu", "@utulsa.edu", "@collegeofsanmateo.edu", "@ttu.edu", "@stephens.edu", "@carrollu.edu", "@nccu.edu", "@southplainscollege.edu", "@calstate.edu", "@neu.edu", "@highlands.edu", "@hillcollege.edu", "@colgate.edu", "@jh.edu", "@nsu.edu", "@academyart.edu", "@rrcc.edu", "@centralgatech.edu", "@franklin.edu", "@gfcmsu.edu", "@daemen.edu", "@bw.edu", "@dabcc.nmsu.edu", "@ccis.edu", "@howard.edu", "@mssc.edu", "@fpcc.edu", "@msj.edu", "@nrao.edu", "@uafs.edu", "@upt.pitt.edu", "@kings.edu", "@wnmu.edu", "@evergreen.edu", "@oregonstate.edu", "@ucsb.edu", "@wccnet.edu", "@trenholmstate.edu", "@sunysccc.edu", "@www.eacc.edu", "@brown.edu", "@morgan.edu", "@cod.edu", "@ptc.edu", "@tntech.edu", "@wallacestate.edu", "@missouristate.edu", "@alamancecc.edu", "@lc.edu", "@halifaxcc.edu", "@csuohio.edu", "@bfcc.edu", "@uakron.edu", "@wilkes.edu", "@pwu.com", "@mwc.edu", "@rollins.edu", "@carroll.edu", "@hazard.kctcs.edu", "@wells.edu", "@uvm.edu", "@keller.edu", "@kishwaukeecollege.edu", "@pueblocc.edu", "@nctc.edu", "@marshall.tstc.edu", "@park.edu", "@sccsc.edu", "@uams.edu", "@rcc.mass.edu", "@mcckc.edu", "@marist.edu", "@wku.edu", "@temple.edu", "@scu.edu", "@scottsdalecc.edu", "@suffolk.edu", "@macauly.cuny.edu", "@kapiolani.hawaii.edu", "@dvc.edu", "@tamucc.edu", "@coastline.edu", "@highpoint.edu", "@edinboro.edu", "@umn.edu", "@ilstu.edu", "@ndu.edu", "@poly.edu", "@platt.edu", "@cwu.edu", "@westtexas.tstc.edu", "@deltastate.edu", "@gptc.edu", "@sctcc.edu", "@ycp.edu", "@evansville.edu", "@wvncc.edu", "@bard.edu", "@kauai.hawaii.edu", "@noc.edu", "@rockford.edu", "@binghamton.edu", "@stu.edu", "@aloma.edu", "@vwc.edu", "@chapman.edu", "@udc.edu", "@waco.tstc.edu", "@emcc.edu", "@ohlone.edu", "@mnsu.edu", "@fmcc.edu", "@clemson.edu", "@snu.edu", "@cfcc.edu", "@frc.edu", "@ct.edu", "@luc.edu", "@madisoncollege.edu", "@umpi.maine.edu", "@cypresscollege.edu", "@okcu.edu", "@quadratacademy.com", "@fdltcc.edu", "@unthsc.edu", "@uat.edu", "@udmercy.edu", "@rrcc.mnscu.edu", "@ccc.edu", "@stvincent.edu", "@york.cuny.edu", "@heartland.edu", "@cord.edu", "@maryville.edu", "@cuyamaca.edu", "@blueridgectc.edu", "@elon.edu", "@albion.edu", "@lafayette.edu", "@seas.upenn.edu", "@bhcc.mass.edu", "@collin.edu", "@ozarks.edu", "@ncc.commnet.edu", "@linnstate.edu", "@wiregrass.edu", "@uwp.edu", "@nwscc.edu", "@umhelena.edu", "@virginiawestern.edu", "@antiochla.edu", "@capellauniversity.edu", "@lakemichigancollege.edu", "@buffalo.edu", "@sandburg.edu", "@uww.edu", "@manoa.hawaii.edu", "@paloverde.edu", "@slu.edu", "@ceu.edu", "@lenoircc.edu", "@ncbc.edu", "@owens.edu", "@mtsac.edu", "@bgsu.edu", "@athenstech.edu", "@cotc.edu", "@clarendoncollege.edu", "@angelo.edu", "@jtcc.edu", "@lbwcc.edu", "@trenton.edu", "@asun.edu", "@collegeofthedesert.edu", "@sunycgcc.edu", "@tusculum.edu", "@stcc.edu", "@uconn.edu", "@msstate.edu", "@smcks.edu", "@carlow.edu", "@everettcc.edu", "@esf.edu", "@millersville.edu", "@fletcher.edu", "@sheridan.edu", "@brooklyn.cuny.edu", "@chemeketa.edu", "@allencc.edu", "@wcc.vccs.edu", "@palomar.edu", "@fhtc.edu", "@bainbridge.edu", "@riohondo.edu", "@cmccd.edu", "@creighton.edu", "@rockinghamcc.edu", "@kwu.edu", "@wfu.edu", "@hamline.edu", "@citadel.edu", "@mwcc.edu", "@cgc.maricopa.edu", "@lynn.edu", "@ccc.commnet.edu", "@claflin.edu", "@mecc.edu", "@bowlinggreen.kctcs.edu", "@newberry.edu", "@pittcc.edu", "@ship.edu", "@southeasterntech.edu", "@ndscs.edu", "@clatsopcc.edu", "@chefs.edu", "@uu.edu", "@rappahannock.edu", "@umkc.edu", "@bergen.edu", "@gmu.edu", "@andrewcollege.edu", "@ojaiusd.org", "@lattc.edu", "@presby.edu", "@sfccmo.edu", "@sunyocc.edu", "@nl.edu", "@southgatech.edu", "@lawsonstate.edu", "@dana.edu", "@udayton.edu", "@riverland.edu", "@cuanschutz.edu", "@sunywcc.edu", "@berkeleycitycollege.edu", "@johnstoncc.edu", "@wts.edu", "@bsc.edu", "@meridiancc.edu", "@hofstra.edu", "@stonechild.edu", "@mtc.edu", "@lit.edu", "@peru.edu", "@rocky.edu", "@tcl.edu", "@lrc.edu", "@tc3.edu", "@drury.edu", "@avc.edu", "@wnec.edu", "@knox.edu", "@d.umn.edu", "@texarkanacollege.edu", "@vernoncollege.edu", "@hgtc.edu", "@smumn.edu", "@eastms.edu", "@pct.edu", "@southmountaincc.edu", "@nicoletcollege.edu", "@principia.edu", "@salemcc.edu", "@smcc.edu", "@wpcc.edu", "@bradley.edu", "@coa.edu", "@ancilla.edu", "@mitchelltech.edu", "@puc.edu", "@sccc.edu", "@starkstate.edu", "@columbustech.edu", "@westcoastuniversity.edu", "@lycoming.edu", "@smccme.edu", "@purdue.edu", "@wilmington.edu", "@mountsaintvincent.edu", "@up.edu", "@newriver.edu", "@jdcc.edu", "@wlac.edu", "@gfc.edu", "@ncat.edu", "@greatbay.edu", "@gatewaycc.edu", "@hfcc.edu", "@clarkstate.edu", "@centenary.edu", "@templejc.edu", "@wwu.edu", "@uoregon.edu", "@muw.edu", "@cbu.edu", "@midlandstech.edu", "@mec.cuny.edu", "@cnuas.edu", "@twu.edu", "@baker.edu", "@massbay.edu", "@lanecollege.edu", "@csusb.edu", "@koc.alaska.edu", "@uj.edu", "@csp.edu", "@rbc.edu", "@appstate.edu", "@fiu.edu", "@wccc.edu", "@cnu.edu", "@mcneese.edu", "@art.edu", "@lbcc.edu", "@middlesex.mass.edu", "@daviscollege.edu", "@allenuniversity.edu", "@itt-tech.edu", "@nsuok.edu", "@campbell.edu", "@coppin.edu", "@nscc.edu", "@hws.edu", "@weber.edu", "@tncc.edu", "@bc3.edu", "@uwrf.edu", "@simmons.edu", "@southernct.edu", "@qvcc.edu", "@sbu.edu", "@peralta.edu", "@brookhavencollege.edu", "@umf.maine.edu", "@peace.edu", "@odc.edu", "@onu.edu", "@pembroke.edu", "@une.edu", "@wvc.edu", "@liunet.edu", "@vgcc.edu", "@scad.edu", "@simmonscollegeky.edu", "@wit.edu", "@mbl.edu", "@apu.edu", "@phoenix.edu", "@usafa.edu", "@fullcoll.edu", "@voorhees.edu", "@www3.sunysuffolk.edu", "@umass.edu", "@nyit.edu", "@chattahoocheetech.edu", "@utm.edu", "@jwcc.edu", "@gccaz.edu", "@kellogg.edu", "@astate.edu", "@georgiasouthern.edu", "@bethelks.edu", "@lco.edu", "@epcc.edu", "@miamioh.edu", "@lfcc.edu", "@capella.edu", "@dbq.edu", "@tsufl.edu", "@vtc.edu", "@csopp.edu", "@eitc.edu", "@pdx.edu", "@dsc.edu", "@bates.edu", "@gmi.edu", "@cpp.edu", "@terra.edu", "@mtsu.edu", "@unh.edu", "@ndsu.edu", "@utrgv.edu", "@www.sunyulster.edu", "@wheatonma.edu", "@rpcc.edu", "@klamathcc.edu", "@sxu.edu", "@sierracollege.edu", "@utdallas.edu", "@lasell.edu", "@rio.maricopa.edu", "@kctcs.edu", "@darton.edu", "@ccp.edu", "@hopkinsville.kctcs.edu", "@cmu.edu", "@iwp.edu", "@middlebury.edu", "@vic.edu", "@contracosta.edu", "@xavier.edu", "@southalabama.edu", "@mwsu.edu", "@rtc.edu", "@wilmu.edu", "@babson.edu", "@augsburg.edu", "@grayson.edu", "@endicott.edu", "@uky.edu", "@columbiastate.edu", "@ursinus.edu", "@cornell.edu", "@cpcc.edu", "@sw.edu", "@csubak.edu", "@waketech.edu", "@bridgeport.edu", "@ucsd.edu", "@ksu.edu", "@eastfieldcollege.edu", "@bucknell.edu", "@bladencc.edu", "@gavilan.edu", "@nmhu.edu", "@mitchellcc.edu", "@nfcc.edu", "@champlain.edu", "@uwsuper.edu", "@valdosta.edu", "@lagcc.cuny.edu", "@yccc.edu", "@tulane.edu", "@cascadia.edu", "@westhillscollege.com", "@skc.edu", "@spcollege.edu", "@marywood.edu", "@wwcc.edu", "@mohave.edu", "@hanover.edu", "@goucher.edu", "@mvsu.edu", "@calvin.edu", "@siue.edu", "@stfrancis.edu", "@ctuonline.edu", "@miami.edu", "@student.42.us.org", "@roswell.enmu.edu", "@csuhayward.edu", "@jscc.edu", "@colum.edu", "@wlsc.wvnet.edu", "@mssm.edu", "@biola.edu", "@eku.edu", "@gocolumbia.edu", "@cccnj.edu", "@uttyler.edu", "@marymount.edu", "@lcc.edu", "@uindy.edu", "@jtsa.edu", "@westshore.edu", "@wakehealth.edu", "@oaklandcc.edu", "@saic.edu", "@cisco.edu", "@csuglobal.edu", "@sulross.edu", "@bgsp.edu", "@trident.edu", "@bowdoin.edu", "@northshore.edu", "@macc.edu", "@nevada.edu", "@ncmissouri.edu", "@eastcentral.edu", "@abcnash.edu", "@clarkson.edu", "@loc.edu", "@iupui.edu", "@drexel.edu", "@northwood.edu", "@judson.edu", "@abtech.edu", "@hendrix.edu", "@calstatela.edu", "@gcsu.edu", "@njit.edu", "@whitman.edu", "@jones.edu", "@b-sc.edu", "@uvu.edu", "@susla.edu", "@oit.edu", "@northeaststate.edu", "@belmont.edu", "@miles.edu", "@wcu.edu", "@tulsacc.edu", "@leeward.hawaii.edu", "@pitt.edu", "@rmu.edu", "@davidsonccc.edu", "@mercymavericks.edu", "@lvc.edu", "@wileyc.edu", "@smu.edu", "@gvltec.edu", "@bhsu.edu", "@alvincollege.edu", "@ctcd.edu", "@northeastern.edu", "@mcw.edu", "@sowela.edu", "@allencollege.edu", "@vjc.edu", "@wilkescc.edu", "@richmondcc.edu", "@georgian.edu", "@iup.edu", "@uog.edu", "@neo.edu", "@washington.edu", "@bigbend.edu", "@fresno.edu", "@northland.edu", "@matc.edu", "@rowan.edu", "@wcsu.edu", "@tcc.fl.edu", "@lahc.edu", "@ubalt.edu", "@umfk.maine.edu", "@chabotcollege.edu", "@owensboro.kctcs.edu", "@mlaw.edu", "@montgomerycollege.edu", "@ecsu.edu", "@vcu.edu", "@nmsu.edu", "@berea.edu", "@npcts.edu", "@davenport.edu", "@fuller.edu", "@mcdaniel.edu", "@wittenberg.edu", "@ssc.edu", "@stonybrook.edu", "@ccv.edu", "@albanytech.edu", "@union.edu", "@milescc.edu", "@gru.edu", "@tougaloo.edu", "@thenicc.edu", "@snhu.edu", "@coconino.edu", "@secon.edu", "@calbaptist.edu", "@nyu.edu", "@centre.edu", "@uri.edu", "@utk.edu", "@ashford.edu", "@ashland.edu", "@cvcc.edu", "@tricountycc.edu", "@gbc.edu", "@nashuacc.edu", "@cctech.edu", "@pupr.edu", "@ccaa.edu", "@byu.edu", "@cncc.edu", "@ucf.edu", "@ucmerced.edu", "@sampsoncc.edu", "@louisburg.edu", "@bluffton.edu", "@cnr.edu", "@highline.edu", "@mansfield.edu", "@mcg.edu", "@gogebic.edu", "@hesston.edu", "@cgu.edu", "@augusta.edu", "@csuci.edu", "@austincc.edu", "@acu.edu", "@greenleaf.edu", "@rpi.edu", "@andrews.edu", "@cmich.edu", "@uw.edu", "@asumh.edu", "@northlakecollege.edu", "@musc.edu", "@dsu.edu", "@nsula.edu", "@delta.edu", "@qcc.edu", "@alfred.edu", "@frostburg.edu", "@dcc.vccs.edu", "@quincycollege.edu", "@arkansasbaptist.edu", "@fvsu.edu", "@emory.edu", "@stillman.edu", "@frontrange.edu", "@jsu.edu", "@emporia.edu", "@emerson.edu", "@hsc.unt.edu", "@bates.ctc.edu", "@uhd.edu", "@wne.edu", "@afit.edu", "@indycc.edu", "@cst.edu", "@carver.edu", "@guptoncollege.edu", "@caspercollege.edu", "@lorainccc.edu", "@vvc.edu", "@lrcc.edu", "@udallas.edu", "@uncw.edu", "@upenn.edu", "@phcc.edu", "@upr.edu", "@shc.edu", "@indianatech.net", "@sfasu.edu", "@buffalostate.edu", "@swc.tc", "@andersonuniversity.edu", "@swccd.edu", "@susqu.edu", "@latech.edu", "@umt.edu", "@vuu.edu", "@wallawalla.edu", "@iona.edu", "@slc.edu", "@wuacc.edu", "@www.cuesta.edu", "@seattlecolleges.edu", "@williams.edu", "@msu.edu", "@usd.edu", "@willamette.edu", "@gpc.edu", "@tcicollege.edu", "@utahtech.edu", "@np.edu", "@tucsonu.edu", "@spu.edu", "@plymouth.edu", "@lamarpa.edu", "@butler.edu", "@brookings.edu", "@duq.edu", "@aurora.edu", "@cccc.edu", "@galencollege.edu", "@kaplan.edu", "@sapc.edu", "@fgcu.edu", "@ucop.edu", "@umbc.edu", "@gc.edu", "@dne.wvnet.edu", "@txstate.edu", "@mercyhurst.edu", "@llu.edu", "@brunswickcc.edu", "@usafa.af.mil", "@racc.edu", "@nhti.edu", "@usouixfalls.edu", "@nwktc.edu", "@nku.edu", "@rockvalleycollege.edu", "@olivet.edu", "@livingstone.edu", "@hccs.edu", "@lasierra.edu", "@strayer.edu", "@panam.edu", "@skylinecollege.edu", "@uaa.alaska.edu", "@sbcc.edu", "@stlcop.edu", "@faytechcc.edu", "@emich.edu", "@nashcc.edu", "@sunyjcc.edu", "@emu.edu", "@fvtc.edu", "@dwc.edu", "@phsc.edu", "@middlesexcc.edu", "@bbc.edu", "@ilisagvik.edu", "@skidmore.edu", "@macalester.edu", "@nwciowa.edu", "@shawnee.edu", "@bentley.edu", "@tsu.edu", "@ntu.edu", "@stchas.edu", "@wbu.edu", "@craftonhills.edu", "@alasu.edu", "@usm.maine.edu", "@stthomas.edu", "@alextech.edu", "@hsc.colorado.edu", "@tcnj.edu", "@www.tjc.edu", "@laredo.edu", "@newhaven.edu", "@harcum.edu", "@fsu.edu", "@prattcc.edu", "@bcc.edu", "@guilford.edu", "@vancouver.wsu.edu", "@www.ojc.edu", "@gonzaga.edu", "@indianhills.edu", "@pvc.maricopa.edu", "@ttuhsc.edu", "@sjrstate.edu", "@carthage.edu", "@unk.edu", "@pit.edu", "@fresnocitycollege.edu", "@knoxvillecollege.edu", "@vul.edu", "@aims.edu", "@whatcom.ctc.edu", "@watc.edu", "@northwestms.edu", "@uamont.edu", "@jjc.edu", "@fmuniv.edu", "@bakeru.edu", "@cornell-iowa.edu", "@bryant.edu", "@wssu.edu", "@albany.edu", "@umes.edu", "@rice.edu", "@yhc.edu", "@uncc.edu", "@northwesterncollege.edu", "@hamptonu.edu", "@wartburg.edu", "@ladhs.org", "@ehc.edu", "@jalc.edu", "@taftcollege.edu", "@uncfsu.edu", "@ipfw.edu", "@cccs.edu", "@svcc.edu", "@ccsu.edu", "@arbor.edu", "@sau.edu", "@carlalbert.edu", "@orangecoastcollege.edu", "@newpaltz.edu", "@central.edu", "@webster.edu", "@canyons.edu", "@dslcc.edu", "@walshcollege.edu", "@sfsu.edu", "@dawson.edu", "@qc.cuny.edu", "@wctc.edu", "@laney.edu", "@apsu.edu", "@indiana.edu", "@uchicago.edu", "@lecom.edu", "@millikin.edu", "@butte.edu", "@beloit.edu", "@mc.edu", "@dcccd.edu", "@scranton.edu", "@aada.edu", "@lanecc.edu", "@ysu.edu", "@morrisbrown.edu", "@ecc.edu", "@npcc.edu", "@southernwv.edu", "@ucsf.edu", "@www.clcmn.edu", "@asa.edu", "@nova.edu", "@minneapolis.edu", "@ferris.edu", "@esu.edu", "@actx.edu", "@jcjc.edu", "@schoolcraft.edu", "@selu.edu", "@haywood.edu", "@quincy.edu", "@kenyon.edu", "@paulquinn.edu", "@bluefieldstate.edu", "@phoenixcollege.edu", "@sctech.edu", "@johnshopkins.edu", "@lsue.edu", "@naz.edu", "@wayne.edu", "@cts.edu", "@montreat.edu", "@elizabethtown.kctcs.edu", "@subr.edu", "@uas.alaska.edu", "@cmmccollege.edu", "@wvu.edu", "@owu.edu", "@nmt.edu", "@atlantic.edu", "@wsu.edu", "@bju.edu", "@sjc.edu", "@samford.edu", "@sdcity.edu", "@wcccd.edu", "@edisonohio.edu", "@sjcme.edu", "@westvalley.edu", "@hccc.edu", "@quinnipiac.edu", "@maricopa.edu", "@amherst.edu", "@alma.edu", "@southern.edu", "@fountainheadcollege.edu", "@moravian.edu", "@ibc.edu", "@uca.edu", "@uaf.edu", "@gvsu.edu", "@ivytech.edu", "@bethanywv.edu", "@rwu.edu", "@sac.edu", "@northwestcollege.edu", "@rose-hulman.edu", "@nhc.edu", "@kilian.edu", "@utc.edu", "@harlingen.tstc.edu", "@uah.edu", "@athens.edu", "@newcollege.edu", "@loras.edu", "@fresnostate.edu", "@pensacolastate.edu", "@carolinascollege.edu", "@hunter.cuny.edu", "@virginia.edu", "@canisius.edu", "@randolph.edu", "@kean.edu", "@lewisu.edu", "@utexas.edu", "@crowder.edu", "@wccc.me.edu", "@swt.edu", "@usl.edu", "@alaska.edu", "@snead.edu", "@irsc.edu", "@itu.edu", "@sandhills.edu", "@nps.edu", "@luthersem.edu", "@usma.edu", "@whittier.edu", "@swcc.edu", "@ad.unc.edu", "@ncc.edu", "@tesc.edu", "@eou.edu", "@govst.edu", "@jefferson.kctcs.edu", "@lcsc.edu", "@glenoaks.cc.mi.us", "@ucmo.edu", "@century.edu", "@ogi.edu", "@patrickhenry.edu", "@littlepriest.edu", "@utpb.edu", "@crk.umn.edu", "@drake.edu", "@cortland.edu", "@sipi.edu", "@usca.edu", "@carrington.edu", "@moultrietech.edu", "@tamu.edu", "@philander.edu", "@kirkwood.edu", "@allegany.edu", "@montana.edu", "@pdc.edu", "@vt.edu", "@gannon.edu", "@saintpaul.edu", "@umdearborn.edu", "@maysville.kctcs.edu", "@hpu.edu", "@ua.edu", "@wscc.edu", "@na.edu", "@jjay.cuny.edu", "@edgewood.edu", "@parkland.edu", "@grinnell.edu", "@ccaurora.edu", "@csi.cuny.edu", "@nicholls.edu", "@radford.edu", "@carleton.edu", "@nwicc.edu", "@bluecc.edu", "@bellevue.edu", "@ripon.edu", "@moorparkcollege.edu", "@csub.edu", "@bethel.edu", "@gmc.cc.ga.us", "@sussex.edu", "@southwesterncc.edu", "@crc.losrios.edu", "@hcc.edu", "@luna.edu", "@isu.edu", "@ccny.cuny.edu", "@tctc.edu", "@pcci.edu", "@norwich.edu", "@wofford.edu", "@fau.edu", "@www.clcillinois.edu", "@marlboro.edu", "@hacc.edu", "@colsouth.edu", "@hastings.edu", "@sju.edu", "@lacitycollege.edu", "@harpercollege.edu", "@butlercc.edu", "@utoledo.edu", "@millsaps.edu", "@macomb.edu", "@mscc.edu", "@icc.edu", "@denvercollegeofnursing.edu", "@redwoods.edu", "@uwm.edu", "@iupuc.edu", "@www.sunybroome.edu", "@mum.edu", "@wagner.edu", "@mc3.edu", "@wcc.yccd.edu", "@mcc.commnet.edu", "@alpenacc.edu", "@pccc.edu", "@ntc.edu", "@lacollege.edu", "@famu.edu", "@sunyorange.edu", "@fortscott.edu", "@morainepark.edu", "@fsc.edu", "@regis.edu", "@wvwc.edu", "@nmmi.edu", "@pierpont.edu", "@gadsdenstate.edu", "@westfield.mass.edu", "@student.uml.edu", "@www.fdtc.edu", "@uco.edu", "@ucdenver.edu", "@arts.ac.uk"
//]

private let REF = Firestore.firestore()

let COLLECTION_USERS = REF.collection("users")
let COLLECTION_REPORTS = REF.collection("reports")

let MOCK_REPORTS: [OSReport] = [
    .init(
        id: NSUUID().uuidString,
        geopoint: GeoPoint(latitude: 37.385, longitude: -122.1),
        reportType: .fire,
        description: "",
        ownerUid: "123",
        ownerUsername: "ashin2022",
        ownerEmail: "ashin2022@gmail.com",
        timestamp: Timestamp(),
        lastUpdated: Timestamp(),
        updaterUsername: "Charles Shin",
        updaterEmail: "cshin12@jhu.edu",
        isAnonymous: true,
        showToPolicesOnly: false,
        geohash: "9q9hrh5sdd",
        locationString: "1 Hacker Way, Cupertino CA",
        status: .unconfirmed
    ),
    .init(
        id: NSUUID().uuidString,
        geopoint: GeoPoint(latitude: 37.334, longitude: -122.009),
        reportType: .fire,
        description: "",
        ownerUid: "123",
        ownerUsername: "ashin2022",
        ownerEmail: "ashin2022@gmail.com",
        timestamp: Timestamp(),
        lastUpdated: Timestamp(),
        updaterUsername: "Charles Shin",
        updaterEmail: "cshin12@jhu.edu",
        isAnonymous: true,
        showToPolicesOnly: true,
        geohash: "9q9hrh5sdd",
        locationString: "1 Hacker Way, Cupertino CA",
        status: .unconfirmed
    ),
    .init(
        id: NSUUID().uuidString,
        geopoint: GeoPoint(latitude: 37.325, longitude: -122.009),
        reportType: .fire,
        description: "",
        ownerUid: "123",
        ownerUsername: "ashin2022",
        ownerEmail: "ashin2022@gmail.com",
        timestamp: Timestamp(),
        lastUpdated: Timestamp(),
        updaterUsername: "Charles Shin",
        updaterEmail: "cshin12@jhu.edu",
        isAnonymous: true,
        showToPolicesOnly: false,
        geohash: "9q9hrh5sdd",
        locationString: "1 Hacker Way, Cupertino CA",
        status: .unconfirmed
    ),
    .init(
        id: NSUUID().uuidString,
        geopoint: GeoPoint(latitude: 36, longitude: -122.009),
        reportType: .fire,
        description: "",
        ownerUid: "123",
        ownerUsername: "ashin2022",
        ownerEmail: "ashin2022@gmail.com",
        timestamp: Timestamp(),
        lastUpdated: Timestamp(),
        updaterUsername: "Charles Shin",
        updaterEmail: "cshin12@jhu.edu",
        isAnonymous: true,
        showToPolicesOnly: false,
        geohash: "9q9hrh5sdd",
        locationString: "1 Hacker Way, Cupertino CA",
        status: .unconfirmed
    )
]
