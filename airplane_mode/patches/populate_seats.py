import frappe
import random

def execute():
    # Fetch all Airplane Tickets without a seat
    tickets = frappe.get_all("Airplane Ticket", filters={"seat": ["is", "not set"]}, fields=["name"])

    for ticket in tickets:
        row = random.randint(1, 99)
        seat_letter = random.choice(['A', 'B', 'C', 'D', 'E'])
        seat = f"{row}{seat_letter}"

        # Update the seat in the database
        frappe.db.set_value("Airplane Ticket", ticket.name, "seat", seat)

    frappe.db.commit()
