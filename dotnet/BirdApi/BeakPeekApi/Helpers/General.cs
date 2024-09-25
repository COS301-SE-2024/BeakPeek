

namespace BeakPeekApi.Helpers
{

    public class GeneralHelper
    {
        private readonly IConfiguration _configuration;
        public GeneralHelper(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public string getVariableFromEnvOrAppsettings(string variable_name)
        {
            string? variable = null;
            variable = _configuration[variable_name];
            if (string.IsNullOrEmpty(variable))
            {
                variable = Environment.GetEnvironmentVariable(variable_name);
            }

            if (variable == null)
            {
                throw new Exception($"{variable_name} Variable not set in environment or appsettings");
            }

            return variable;

        }

    }

}

