import frappe
import random
from frappe.model.document import Document

class AirplaneTicket(Document):
    def before_insert(self):
        row_number = random.randint(1, 99)
        seat_letter = random.choice(['A', 'B', 'C', 'D', 'E'])
        self.seat = f"{row_number}{seat_letter}"

    def before_submit(self):
        if self.status != "Boarded":
            frappe.throw("Hold up! You can only submit the ticket if the passenger has boarded.")

    def on_submit(self):
        if self.flight:
            flight_doc = frappe.get_doc("Airplane Flight", self.flight)
            flight_doc.status = "Completed"
            flight_doc.save()
