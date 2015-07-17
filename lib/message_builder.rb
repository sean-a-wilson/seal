class MessageBuilder

  attr_accessor :pull_requests, :report, :mood, :old_pull_requests

  def initialize(pull_requests, mood)
    @pull_requests = pull_requests
    @mood = mood
  end

  def informative
   if @pull_requests == {}
      no_pull_requests
    else
      list_pull_requests
      @report
    end
  end

  def angry
    @alert = ""
    check_old_pull_requests
    return @alert if @old_pull_requests.length > 0
    ""
  end

  def check_old_pull_requests
    @old_pull_requests = []
    n = 0
    @pull_requests.each do |title, pull_request|
      n += 1
      @alert = @alert + present(title, n)
      @old_pull_requests << pull_request if rotten?(pull_request)
    end
    @alert = "AAAAAAARGH! #{these} #{pr_plural} not been updated in over 2 days.\n\n" + @alert + "\n\n Remember each time you time you forget to review your pull requests, a baby seal dies."
  end

  def rotten?(pull_request)
    return true if pull_request["updated"] + 2 < Date.today
    false
  end

  private

  def list_pull_requests
  @report = "Good morning team! \n\n Here are the pull requests that need to be reviewed today:\n\n"
    n = 0
    @pull_requests.each_key do |pull_request|
      n += 1
      @report = @report + present(pull_request, n)
    end
  @report = @report + "\nMerry reviewing!"
  end

  def no_pull_requests
    "Good morning team! It's a beautiful day! :happyseal: :happyseal: :happyseal:\n\nNo pull requests to review today! :rainbow: :sunny: :metal: :tada:"
  end

  def comments(pull_request)
    return " comment" if @pull_requests[pull_request]["comments_count"] == "1"
    " comments"
  end

  def these
    return "This" if @old_pull_requests == "1"
    "These"
  end

  def pr_plural
    return "pull request has" if @old_pull_requests == "1"
    "pull requests have"
  end

  def present(pull_request, index)
    "#{index}) *" + @pull_requests[pull_request]["repo"] + "* | " +
    @pull_requests[pull_request]["author"] +
    "\n<" + @pull_requests[pull_request]["link"] + "|" + pull_requests[pull_request]["title"]  + "> - " +
    @pull_requests[pull_request]["comments_count"] + comments(pull_request) + "\n"
  end

end