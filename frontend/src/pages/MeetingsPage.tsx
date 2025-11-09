import { Link } from 'react-router-dom';
import { Button } from '../components/common/Button';
import { Card } from '../components/common/Card';
import { Loading } from '../components/common/Loading';
import { useMeetings } from '../hooks/useMeetings';
import { formatDate } from '../utils/date.utils';

export const MeetingsPage: React.FC = () => {
  const { data: meetings, isLoading, error } = useMeetings();

  if (isLoading) {
    return <Loading />;
  }

  if (error) {
    return (
      <div className="p-4 bg-red-50 border border-red-200 rounded-md">
        <p className="text-red-700">Failed to load meetings. Please try again.</p>
      </div>
    );
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Meetings</h1>
          <p className="mt-2 text-gray-600">
            Upload and manage swimming meet qualification standards
          </p>
        </div>
        <Link to="/meetings/new">
          <Button>Upload Meeting</Button>
        </Link>
      </div>

      {meetings && meetings.length === 0 ? (
        <Card>
          <div className="text-center py-12">
            <svg
              className="mx-auto h-12 w-12 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            <h3 className="mt-2 text-sm font-medium text-gray-900">No meetings</h3>
            <p className="mt-1 text-sm text-gray-500">
              Get started by uploading a meeting PDF.
            </p>
            <div className="mt-6">
              <Link to="/meetings/new">
                <Button>Upload Meeting</Button>
              </Link>
            </div>
          </div>
        </Card>
      ) : (
        <div className="grid grid-cols-1 gap-6">
          {meetings?.map((meeting) => (
            <Link key={meeting.id} to={`/meetings/${meeting.id}`}>
              <Card className="hover:shadow-lg transition-shadow cursor-pointer">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className="text-xl font-semibold text-gray-900">
                      {meeting.name}
                    </h3>
                    <div className="mt-4 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                      <div>
                        <p className="text-sm font-medium text-gray-500">Season</p>
                        <p className="text-sm text-gray-900">{meeting.season}</p>
                      </div>
                      {meeting.region && (
                        <div>
                          <p className="text-sm font-medium text-gray-500">Region</p>
                          <p className="text-sm text-gray-900">{meeting.region}</p>
                        </div>
                      )}
                      {meeting.promoter && (
                        <div>
                          <p className="text-sm font-medium text-gray-500">Promoter</p>
                          <p className="text-sm text-gray-900">{meeting.promoter}</p>
                        </div>
                      )}
                      <div>
                        <p className="text-sm font-medium text-gray-500">Pool Type</p>
                        <p className="text-sm text-gray-900">
                          {meeting.pool_required === 'LC' ? 'Long Course (50m)' : 'Short Course (25m)'}
                        </p>
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-500">Qualification Window</p>
                        <p className="text-sm text-gray-900">
                          {formatDate(meeting.window_start)} - {formatDate(meeting.window_end)}
                        </p>
                      </div>
                      {meeting.age_rule_date && (
                        <div>
                          <p className="text-sm font-medium text-gray-500">Age Rule Date</p>
                          <p className="text-sm text-gray-900">{formatDate(meeting.age_rule_date)}</p>
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="ml-4">
                    <div className="flex items-center justify-center h-12 w-12 rounded-full bg-purple-100">
                      <svg
                        className="h-6 w-6 text-purple-600"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2}
                          d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                        />
                      </svg>
                    </div>
                  </div>
                </div>
                <div className="mt-4 pt-4 border-t border-gray-200">
                  <p className="text-xs text-gray-500">
                    Added {formatDate(meeting.created_at || '')}
                  </p>
                </div>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
};
