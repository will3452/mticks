import 'package:flutter/material.dart'; 

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and conditions"),
      ),
      body:SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("YOUR RESERVATION TICKET SERVES AS AN OFFICIAL FARE TICKET FOR ALL INTENTS AND PURPOSE."),
                SizedBox(
                  height: 20,
                ),
                Text("CHECK IN TIME: 20 minutes before scheduled departure. Failure of passengers to present themselves for carriage within such time shall result in the cancellation of their reservation and their seats shall be given to chance passengers."),
                SizedBox(
                  height: 20,
                ),
                Text("VALIDITY OF THIS TICKET: On the date stated herein or on the rebooked date."),
                SizedBox(
                  height: 20,
                ), 
                Text("NON-REFUNDABLE TICKET: Your reservation ticket shall be non-refundable except only in cases of force majeure or trip cancellations through the fault of the company in which case the passenger has the option to claim a refund or to rebook the ticket, without any surcharge, within fifteen (15) calendar days from the trip date written on the ticket."),
                SizedBox(
                  height: 20,
                ), 
                Text("However, the passenger may likewise rebook this ticket at any time before the departure date or within fifteen (15) calendar days from trip date appearing on the ticket. Failure to rebook this ticket within the aforesaid period shall result in forfeiture of paid fare in favor of the company. Rebooking is allowed only once and shall be subject to a common surcharge rate of TEN PERCENT (10%) of the paid fare."),
                SizedBox(
                  height: 20,
                ),Text("CANCELLATION/CHANGE OF SCHEDULE: Victory Liner, Inc. reserves the right to cancel trips or change it's time schedules and/or dates of departure without prior notice."),
                SizedBox(
                  height: 20,
                ),
                Text("LIMITATION OF LIABILITY FOR LOSS/ DAMAGE OR PERSONAL BELONGINGS/LUGGAGE: Victory Liner, Inc. assumes no resposibility for loss or damage of effect, luggage or other personal belongings carried by passengers unless these are declared and shown to and a list thereof is given and freight charges are paid thereon to the shipping clerk or conductor, and the passenger complies with the instructions of the shipping clerk or conductor relative to their care and safekeeping."),
                SizedBox(
                  height: 20,
                ),
                Text("LOST PASSENGER TICKETS FOR ANY CAUSE WHATSOEVER SHALL NOT BE RETURNED OR REPLACED BY THE COMPANY AND THE PASSENGER WIL BE REQUIRED TO PAY HIS/HER FARE A NEW."),
                SizedBox(
                  height: 20,
                ),
                Text("ANY UNAUTHORIZED ERASURE OR ALTERATION OF THE INFORMATION STATED ON THE REVERSE SIDE HEREOF SHALL RENDER THIS RESERVATION TICKET NULL AND VOID."),
                SizedBox(
                  height: 40,
                ),
                Text("Privacy Policy"),
                SizedBox(
                  height: 20,
                ),
                Text("In the Privacy Policy, we explain how we collect, use, manage, and store the information’s.This Privacy Policy describes our policies and procedures on the collection, use, management of your information when you use the service. We also let you know of your privacy right"),
                SizedBox(
                  height: 20,
                ),
                Text("Collection and Use"),
                SizedBox(
                  height: 20,
                ),
                Text("Personal Data"),
                SizedBox(
                  height: 20,
                ),
                Text("In using our service, we may ask you to provide us with some of your personal information that can be used to contact or identify you. This includes:"),
                Text("Email Address, First Name, Last Name, Phone Number"),
                SizedBox(
                  height: 20,
                ),
                Text("Information Collected While Using the Application"),
                Text("While using our application, we may collect some information in order to provide all the features of our application with your prior permission. This includes:"),
                Text("Location Information, Pictures from your device’s camera and gallery"),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
