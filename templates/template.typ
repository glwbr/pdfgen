#let data = json(sys.inputs.data-file)

= #data.title
*Client:* #data.client_name
*Service:* #data.service
*Amount:* #data.amount
*Date:* #data.date
