class ProposalsController < ApplicationController

# POST /proposals
# POST /proposals.json
  def create
    proposal_json = params[:proposal]
    #result = Proposal.create_from_user(session[:user_id],
    #                                   session[:group_id],
    #                                   session[:round_id],
    #                                   proposal_json)
    from_id = proposal_json[:from].to_i
    to_id = proposal_json[:to].to_i
    money_a = proposal_json[:moneys][0].to_i
    money_b = proposal_json[:moneys][1].to_i
    money_c = proposal_json[:moneys][2].to_i
    group_id = proposal_json[:group_id].to_i
    p = Proposal.submit_proposal(from: from_id,
                                to: to_id,
                                money_a: money_a,
                                money_b: money_b,
                                money_c: money_c,
                                group_id: group_id)
    # result may fail

    respond_to do |format|
      format.json { render json: {:proposal => p}}
    end


  end

  def accept
    proposal_id = params[:proposal_id].to_i
    from_id = params[:from].to_i
    to_id = params[:to].to_i
    group_id = params[:group_id].to_i

    p = Proposal.accept_proposal(proposal_id: proposal_id,
                                 group_id: group_id,
                                 from: from_id,
                                 to: to_id)

    render json: p
  end

end

