#Author: Walt Mamed

def getImapMsg(imapServer,imapAccount,imapPasswd,inImapSubj,inImapFrom, uniqueBodyText = nil, debug='0')
  if debug == '1'
    puts "getMsg> Subj: #{inImapSubj}, From: #{inImapFrom}"
    puts "getMsg> #{imapServer}, #{imapAccount}, #{imapPasswd}"
    puts "getMsg> uniqueBodyText = <#{uniqueBodyText}>"
  end
  searchCount = 0
  msgFound = 0

  until ( searchCount > 120 || msgFound ==1)
    #until ( searchCount > 5 || msgFound ==1)  # for debugging
    sleep 10
    # Port and SSL required for Gmail
    imap = Net::IMAP.new(imapServer, 993, true)
    imap.login(imapAccount, imapPasswd)
    # Use Inbox when generic QA account is known
    imap.select('Inbox')

    searchResult = imap.search(["FROM",  inImapFrom , "SUBJECT", inImapSubj, "UNSEEN"]) #standard
    string = imap.status("Inbox", ["MESSAGES"]).to_s
    #puts "string = <#{string}>"
    if string =~ /\d.*/
      msgCount = $&
    else
      puts "No match om regex"
    end
    puts "getMsg> searchResult = <#{searchResult.inspect}>  msgCount = <#{msgCount}>  Elapsed = #{searchCount} seconds"; $stdout.flush
    if searchResult != nil
      puts "getMsg> **** Both Subj & From matched!!!"
      searchResult.each do |message_id|
        #envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
        @imapBody = imap.fetch(message_id, "BODY[TEXT]").to_s
        @imapBody.gsub!(/=\\r\\n/, '')
        #puts "***********\n@imapBody = #{@imapBody}"
        @imapBody.gsub!(/\\r\\n +/, ' ')
        #puts "\n*********** @imapBody = \n#{@imapBody}\n"
        if @imapBody =~ /#{uniqueBodyText}/
          puts "Found '#{uniqueBodyText}' in message #{message_id}"
          msgFound = 1
          # Uncomment these to delete the message
          resp = imap.store(message_id, "+FLAGS", [:Seen, :Deleted])
          puts "getMsg> store #{resp}"
          resp = imap.expunge
          puts "getMsg> expunge #{resp}"
          break
        else
          puts "NO MATCH on '#{uniqueBodyText}' in message #{message_id}"
          #break
        end
      end #do
    end #if
    searchCount += 10
    #puts "Waited #{searchCount} seconds"
    #puts "IMAP logout"
    resp = imap.close
    puts "getMsg> close imap> #{resp}"
    imap.logout() # recommended or disconnects lockup the thread
    #puts "IMAP disconnect"
    imap.disconnect()
  end #until

  return @imapBody
end #def getImapMsg
