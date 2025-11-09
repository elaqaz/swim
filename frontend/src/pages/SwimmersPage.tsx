import { Link } from 'react-router-dom';
import { Button } from '../components/common/Button';
import { Card } from '../components/common/Card';
import { Loading } from '../components/common/Loading';
import { useSwimmers } from '../hooks/useSwimmers';
import { formatDate, calculateAge } from '../utils/date.utils';

export const SwimmersPage: React.FC = () => {
  const { data: swimmers, isLoading, error } = useSwimmers();

  if (isLoading) {
    return <Loading />;
  }

  if (error) {
    return (
      <div className="p-4 bg-red-50 border border-red-200 rounded-md">
        <p className="text-red-700">Failed to load swimmers. Please try again.</p>
      </div>
    );
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Swimmers</h1>
          <p className="mt-2 text-gray-600">
            Manage your swimmers and track their performances
          </p>
        </div>
        <Link to="/swimmers/new">
          <Button>Add New Swimmer</Button>
        </Link>
      </div>

      {swimmers && swimmers.length === 0 ? (
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
                d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
              />
            </svg>
            <h3 className="mt-2 text-sm font-medium text-gray-900">No swimmers</h3>
            <p className="mt-1 text-sm text-gray-500">
              Get started by adding a new swimmer.
            </p>
            <div className="mt-6">
              <Link to="/swimmers/new">
                <Button>Add New Swimmer</Button>
              </Link>
            </div>
          </div>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {swimmers?.map((swimmer) => (
            <Link key={swimmer.id} to={`/swimmers/${swimmer.se_membership_id}`}>
              <Card className="hover:shadow-lg transition-shadow cursor-pointer h-full">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-gray-900">
                      {swimmer.first_name} {swimmer.last_name}
                    </h3>
                    <div className="mt-2 space-y-1">
                      <p className="text-sm text-gray-600">
                        <span className="font-medium">Age:</span>{' '}
                        {calculateAge(swimmer.dob)} years
                      </p>
                      <p className="text-sm text-gray-600">
                        <span className="font-medium">Sex:</span>{' '}
                        {swimmer.sex === 'M' ? 'Male' : 'Female'}
                      </p>
                      <p className="text-sm text-gray-600">
                        <span className="font-medium">Club:</span> {swimmer.club}
                      </p>
                      {swimmer.se_membership_id && (
                        <p className="text-sm text-gray-600">
                          <span className="font-medium">SE ID:</span>{' '}
                          {swimmer.se_membership_id}
                        </p>
                      )}
                    </div>
                  </div>
                  <div className="ml-4">
                    <div className="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center">
                      <span className="text-xl font-semibold text-blue-600">
                        {swimmer.first_name.charAt(0)}
                        {swimmer.last_name.charAt(0)}
                      </span>
                    </div>
                  </div>
                </div>
                <div className="mt-4 pt-4 border-t border-gray-200">
                  <p className="text-xs text-gray-500">
                    Added {formatDate(swimmer.created_at || '')}
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
