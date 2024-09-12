using BeakPeekApi.Helpers;

public class GeneralHelperTest
{
    private readonly GeneralHelper _generalHelper;

    public GeneralHelperTest()
    {
        _generalHelper = new GeneralHelper(Mocks.GetConfiguration());
    }

    [Theory]
    [InlineData("FLICKR_API_KEY", "your_api_key")]
    [InlineData("AzureBlobStorage:BlobContainerName", "azure_connection_string")]
    [InlineData("AzureBlobStorage:StorageConnectionString", "DefaultEndpointsProtocol=https;AccountName=mockstorage;AccountKey=XXXXX/XXXXXXXXX+XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX+XXX/XX/XXXXX+XXXXXXXXX==;EndpointSuffix=core.windows.net")]
    public void GetVariable(string variable_name, string expected)
    {
        /// Act
        var result = _generalHelper.getVariableFromEnvOrAppsettings(variable_name);

        /// Assert
        Assert.Equal(result, expected);
    }

    [Fact]
    public void GetVariable_From_Environment()
    {
        ///Arrange
        string var_name = "test_variable";
        string var_value = "test_variable_value";
        Environment.SetEnvironmentVariable(var_name, var_value);

        /// Act
        var result = _generalHelper.getVariableFromEnvOrAppsettings(var_name);

        ///Assert
        Assert.Equal(result, var_value);
    }

    [Fact]
    public void GetVariable_ThrowException()
    {
        Assert.Throws<Exception>(() => _generalHelper.getVariableFromEnvOrAppsettings("variable_that_doesnt_exist"));
    }
}
