require 'win32ole'

outlook = WIN32OLE.new('Outlook.Application')

olMailItem = 0
# olAppointmentItem = 1
# olContactItem = 2
# olTaskItem = 3
# olJournalItem = 4
# olNoteItem = 5
# olPostItem = 6

message = outlook.CreateItem(0)
message.Subject = 'Flatline Error From Ruby Test'
message.Body = 'The following service(s) have failed'
message.To = 'davidturner@gamestop.com'
#message.Recipients.Add ''
#message.Recipients.Add ''
#message.Attachments.Add(filename)
#message.Save
message.Send