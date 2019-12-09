class SubmissionTestRun < ApplicationRecord
  belongs_to :submission

  delegate :solution, to: :submission

  def results_status
    super.try(&:to_sym)
  end

  def pass?
    results_status == :pass
  end

  def errored?
    results_status == :error
  end

  def failed?
    results_status == :fail
  end

  def failed_tests
    tests.
      map { |test| SubmissionTestRunTest.new(solution, test) }.
      select(&:failed?)
  end

  def to_partial_path
    return "research/submission_test_runs/no_results" if results_status.nil?

    "research/submission_test_runs/#{results_status}"
  end
end