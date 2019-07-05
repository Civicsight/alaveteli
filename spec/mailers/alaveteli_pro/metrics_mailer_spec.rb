require 'spec_helper'

RSpec.describe AlaveteliPro::MetricsMailer do
  let(:message) do
    AlaveteliPro::MetricsMailer.
      weekly_report(data, feature_enabled?(:pro_pricing)).
        message
  end

  let(:data) do
    {
      new_pro_requests: 104,
      total_new_requests: 37535,
      new_batches: 3,
      new_signups: 5,
      total_accounts: 284,
      active_accounts: 42,
      paying_users: 44,
      discounted_users: 7,
      trialing_users: 8,
      past_due_users: { count: 0, subs: 0 },
      pending_cancellations:
        { count: 2, subs: ['sub_1234', 'sub_1235'] },
      unpaid_users: { count: 0, subs: 0 },
      unknown_users: 0,
      new_and_returning_users:
        { count: 6,
          subs:
            ['sub_1236',
             'sub_1237',
             'sub_1238',
             'sub_1239',
             'sub_1240',
             'sub_1241'] },
      canceled_users: { count: 0, subs: [] }
    }
  end

  describe '.send_weekly_report' do
    subject { described_class.send_weekly_report }

    it 'should deliver the weekly_report email' do
      expect { subject }.to(
        change(ActionMailer::Base.deliveries, :size).by(1)
      )
    end
  end

  describe '#weekly_report' do
    it 'sends the email to the pro contact address' do
      expect(message.to).to eq [AlaveteliConfiguration.pro_contact_email]
    end

    it 'sends the email from the pro contact address' do
      expect(message.from).to eq [AlaveteliConfiguration.pro_contact_email]
    end

    it 'has a subject including "Weekly Metrics"' do
      expect(message.subject).to match('Weekly Metrics')
    end

    it 'includes the number of Pro accounts' do
      expect(message.body).to include('Total number of Pro accounts: 284')
    end

    context 'pro pricing disabled' do
      it 'does not include paying user info' do
        expect(message.body).to_not include('Number of paying users: 44')
      end

      it 'reports the number of new Pro accounts' do
        expect(message.body).to include('New Pro accounts this week: 5')
      end

      it 'does not report the number of new Pro subscriptions' do
        expect(message.body).to_not include('New Pro subscriptions this week:')
      end
    end

    context 'pro pricing enabled', feature: :pro_pricing do
      it 'reports the number of new Pro subscriptions' do
        expect(message.body).to include('New Pro subscriptions this week: 6')
      end

      it 'does not report the number of new Pro accounts' do
        expect(message.body).to_not include('New Pro accounts this week:')
      end

      it 'includes paying user info' do
        expect(message.body).to include('Number of paying users: 44')
      end

      describe 'returning subscribers' do
        it 'correctly calculates the number of returning subscribers' do
          expect(message.body).
            to include('(includes 1 returning subscriber)')
        end

        it 'pluralises "subscriber"' do
          data[:new_and_returning_users][:count] = 7
          expect(message.body).
            to include('(includes 2 returning subscribers)')
        end

        it 'does not show the returning subscribers note if there are none' do
          data[:new_and_returning_users][:count] = 5
          expect(message.body).
            to_not include('(includes 0 returning subscriber')
        end
      end

      describe 'listing subscriber dashboard links' do
        it 'should include an indented bullet point list' do
          expect(message.body).to include(
            <<~TXT
              Pending cancellations: 2
                * https://dashboard.stripe.com/subscriptions/sub_1234
                * https://dashboard.stripe.com/subscriptions/sub_1235
            TXT
          )
        end
      end
    end
  end
end
