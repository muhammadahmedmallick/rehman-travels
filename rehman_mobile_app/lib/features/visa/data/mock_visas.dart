// Mock visa payload used as a fallback while the real
// `/api/mobile/visas/types/` endpoint isn't ready yet, so the UI
// (home country picker, details screen, apply flow) can be built
// and reviewed end-to-end without a live backend.
//
// Shape matches the spec the backend will ship:
// {
//   "count": N,
//   "next": null,
//   "previous": null,
//   "results": [
//     { "id", "title", "subtitle", "country_code",
//       "variants": [ { "id", "title", "price", "currency",
//         "rules": [ { "id", "title", "rule_type", "icon" } ] } ] }
//   ]
// }
//
// Delete this file + the `_mockVisaTypes` fallback branch in
// `visa_provider.dart` when the real endpoint ships clean data.

const Map<String, dynamic> kMockVisaTypesResponse = {
  'count': 4,
  'next': null,
  'previous': null,
  'results': [
    {
      'id': 1,
      'title': 'UAE Visa',
      'subtitle': 'Quick processing, e-visa delivered to your inbox',
      'country_code': 'ARE',
      'variants': [
        {
          'id': 101,
          'title': '30 Days Single Entry',
          'price': 37000,
          'currency': 'PKR',
          'rules': [
            {
              'id': 1001,
              'title': 'Valid Passport Required',
              'rule_type': 'general',
              'icon': 'fa-passport',
            },
            {
              'id': 1002,
              'title': 'NIC / Smart CNIC',
              'rule_type': 'Adult / Child / Infant',
              'icon': 'fa-id-card',
            },
            {
              'id': 1003,
              'title': 'Pictures',
              'rule_type': '01 passport size picture with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 1004,
              'title': 'Contact Information',
              'rule_type': 'Emergency contact number',
              'icon': 'fa-phone',
            },
            {
              'id': 1005,
              'title': 'Reservations',
              'rule_type':
                  'Tentative flight and hotel reservation provided by Sastaticket',
              'icon': 'fa-ticket',
            },
            {
              'id': 1006,
              'title': 'Family Details',
              'rule_type': 'Applicant\'s mother and father names',
              'icon': 'fa-users',
            },
            {
              'id': 1007,
              'title': 'Bank Details',
              'rule_type': 'Bank statement with bank certificate',
              'icon': 'fa-university',
            },
          ],
        },
        {
          'id': 102,
          'title': '60 Days Single Entry',
          'price': 42500,
          'currency': 'PKR',
          'rules': [
            {
              'id': 2001,
              'title': 'Valid Passport Required',
              'rule_type': 'general',
              'icon': 'fa-passport',
            },
            {
              'id': 2002,
              'title': 'NIC / Smart CNIC',
              'rule_type': 'Adult / Child / Infant',
              'icon': 'fa-id-card',
            },
            {
              'id': 2003,
              'title': 'Pictures',
              'rule_type': '01 passport size picture with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 2004,
              'title': 'Contact Information',
              'rule_type': 'Emergency contact number',
              'icon': 'fa-phone',
            },
            {
              'id': 2005,
              'title': 'Reservations',
              'rule_type':
                  'Tentative flight and hotel reservation provided by Sastaticket',
              'icon': 'fa-ticket',
            },
            {
              'id': 2006,
              'title': 'Family Details',
              'rule_type': 'Applicant\'s mother and father names',
              'icon': 'fa-users',
            },
            {
              'id': 2007,
              'title': 'Bank Details',
              'rule_type': 'Bank statement with bank certificate',
              'icon': 'fa-university',
            },
          ],
        },
        {
          'id': 103,
          'title': '90 Days Multiple Entry',
          'price': 68500,
          'currency': 'PKR',
          'rules': [
            {
              'id': 3001,
              'title': 'Valid Passport Required',
              'rule_type': 'general',
              'icon': 'fa-passport',
            },
            {
              'id': 3002,
              'title': 'NIC / Smart CNIC',
              'rule_type': 'Adult / Child / Infant',
              'icon': 'fa-id-card',
            },
            {
              'id': 3003,
              'title': 'Pictures',
              'rule_type': '01 passport size picture with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 3004,
              'title': 'Bank Details',
              'rule_type': 'Bank statement with bank certificate (last 6 months)',
              'icon': 'fa-university',
            },
            {
              'id': 3005,
              'title': 'Employment Letter',
              'rule_type': 'Company letterhead stating designation and salary',
              'icon': 'fa-briefcase',
            },
            {
              'id': 3006,
              'title': 'Reservations',
              'rule_type':
                  'Tentative flight and hotel reservation provided by Sastaticket',
              'icon': 'fa-ticket',
            },
          ],
        },
      ],
    },
    {
      'id': 2,
      'title': 'Umrah Visa',
      'subtitle': 'Complete Umrah package with visa assistance',
      'country_code': 'SAU',
      'variants': [
        {
          'id': 201,
          'title': '15 Days Umrah Visa',
          'price': 55000,
          'currency': 'PKR',
          'rules': [
            {
              'id': 4001,
              'title': 'Valid Passport Required',
              'rule_type': 'Minimum 6 months validity',
              'icon': 'fa-passport',
            },
            {
              'id': 4002,
              'title': 'NIC / Smart CNIC',
              'rule_type': 'Adult / Child / Infant',
              'icon': 'fa-id-card',
            },
            {
              'id': 4003,
              'title': 'Pictures',
              'rule_type': '02 passport size pictures with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 4004,
              'title': 'Vaccination Certificate',
              'rule_type': 'Meningitis and COVID-19 vaccination required',
              'icon': 'fa-file',
            },
            {
              'id': 4005,
              'title': 'Mahram Proof',
              'rule_type': 'For females under 45, mahram documents required',
              'icon': 'fa-users',
            },
          ],
        },
        {
          'id': 202,
          'title': '30 Days Umrah Visa',
          'price': 72000,
          'currency': 'PKR',
          'rules': [
            {
              'id': 5001,
              'title': 'Valid Passport Required',
              'rule_type': 'Minimum 6 months validity',
              'icon': 'fa-passport',
            },
            {
              'id': 5002,
              'title': 'NIC / Smart CNIC',
              'rule_type': 'Adult / Child / Infant',
              'icon': 'fa-id-card',
            },
            {
              'id': 5003,
              'title': 'Pictures',
              'rule_type': '02 passport size pictures with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 5004,
              'title': 'Vaccination Certificate',
              'rule_type': 'Meningitis and COVID-19 vaccination required',
              'icon': 'fa-file',
            },
            {
              'id': 5005,
              'title': 'Hotel Booking',
              'rule_type': 'Confirmed accommodation in Makkah & Madinah',
              'icon': 'fa-ticket',
            },
          ],
        },
      ],
    },
    {
      'id': 3,
      'title': 'Turkey Visa',
      'subtitle': 'Gateway to Europe — e-visa in 3–5 working days',
      'country_code': 'TUR',
      'variants': [
        {
          'id': 301,
          'title': '30 Days Single Entry',
          'price': 28500,
          'currency': 'PKR',
          'rules': [
            {
              'id': 6001,
              'title': 'Valid Passport Required',
              'rule_type': 'Minimum 6 months validity',
              'icon': 'fa-passport',
            },
            {
              'id': 6002,
              'title': 'Pictures',
              'rule_type': '02 passport size pictures with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 6003,
              'title': 'Bank Details',
              'rule_type': 'Bank statement with bank certificate',
              'icon': 'fa-university',
            },
            {
              'id': 6004,
              'title': 'Reservations',
              'rule_type':
                  'Return flight and hotel reservation',
              'icon': 'fa-ticket',
            },
          ],
        },
      ],
    },
    {
      'id': 4,
      'title': 'Thailand Visa',
      'subtitle': 'Popular tourist destination — visa on arrival available',
      'country_code': 'THA',
      'variants': [
        {
          'id': 401,
          'title': '60 Days Tourist Visa',
          'price': 18500,
          'currency': 'PKR',
          'rules': [
            {
              'id': 7001,
              'title': 'Valid Passport Required',
              'rule_type': 'Minimum 6 months validity',
              'icon': 'fa-passport',
            },
            {
              'id': 7002,
              'title': 'Pictures',
              'rule_type': '02 passport size pictures with white background',
              'icon': 'fa-camera',
            },
            {
              'id': 7003,
              'title': 'Bank Details',
              'rule_type': 'Bank statement (minimum PKR 200,000)',
              'icon': 'fa-university',
            },
            {
              'id': 7004,
              'title': 'Reservations',
              'rule_type': 'Return flight and hotel reservation',
              'icon': 'fa-ticket',
            },
          ],
        },
      ],
    },
  ],
};
